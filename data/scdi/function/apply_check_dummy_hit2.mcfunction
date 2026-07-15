# called still as+at the dummy, from apply_check_dummy_hit.mcfunction.
# checked and acted on synchronously in the SAME damage-processing step as
# the hit itself (advancement rewards fire as a direct reaction to the
# damage already being applied), so this already runs before the entity's
# own tick-based death handling gets a chance to act.
#
# a mortal dummy is lethal-hit the instant its SIMULATED player-sized
# health (scdi_dummy_sim_hp, drained in apply_check_dummy_hit.mcfunction,
# regenerated in apply_dummy_regen_heal.mcfunction, capped at
# dummy_one_shot_damage) reaches 0. this is what makes CUMULATIVE/sustained
# damage kill a dummy exactly like it would a real player - two hits of 12
# each wouldn't individually reach a single-hit threshold, but their SUM
# correctly does, the same way it would against a real 20-health player.
# checking only the big buffer pool (dummy_max_health) for this, like an
# earlier version of this file did, meant a dummy could shrug off dozens
# of hits that would have killed a real player many times over, since none
# of them individually dented a 1000-point pool. the buffer pool is kept
# as a backstop (if it's ever somehow drained to 0 first, extremely
# unlikely given how much bigger it is than the simulated pool) so item
# loss still can't happen even in a weird edge case.
scoreboard players set $mortal_lethal scdi_const 0
execute if score @s scdi_dummy_sim_hp matches ..0 run scoreboard players set $mortal_lethal scdi_const 1
execute if score @s scdi_health matches ..0 run scoreboard players set $mortal_lethal scdi_const 1

# fetched once here, reused below by every chat announcement this file
# fires (dummy_announce_range - see load.mcfunction) - scopes them to
# nearby players instead of the whole server.
execute store result storage scdi:tmp26 range int 1 run data get storage scdi:config dummy_announce_range 1

# debugging aid (debug_hit_messages, default off) - shows the exact values
# this file's lethal-hit decision is based on.
execute if data storage scdi:config {debug_hit_messages:1b} run tellraw @a [{"text":"[hit-dbg] apply_check_dummy_hit2 - scdi_health(score)=","color":"gray"},{"score":{"name":"@s","objective":"scdi_health"}},{"text":" sim_hp(tenths)=","color":"gray"},{"score":{"name":"@s","objective":"scdi_dummy_sim_hp"}},{"text":" mortal_lethal=","color":"gray"},{"score":{"name":"$mortal_lethal","objective":"scdi_const"}},{"text":" invincible=","color":"gray"},{"score":{"name":"@s","objective":"scdi_dummy_invincible"}}]

# one-shot announcement (optional, dummy_announce_one_shot, default on):
# fires only on the dummy's first-ever hit (scdi_dummy_hit unset, meaning it
# was still at full/spawn health going into this specific hit) if this hit
# alone was lethal - the clearest available signal of a genuine one-shot,
# mirroring check_one_shot.mcfunction's logic for players. MORTAL dummies
# only - an invincible dummy never truly dies, so "one-shot" doesn't apply
# to it (that's what the separate "Cheated Death!" system is for). without
# this exclusion, mortal_lethal stays permanently true for an invincible
# dummy once its sim_hp first goes negative (it's never reset back to a
# sane value for invincible dummies), and scdi_dummy_hit gets reset far
# more often than a real "fresh encounter" - passive regen only needs to
# reach the CURRENT small segment's ceiling, not the whole pool - so this
# was re-firing repeatedly during what was really one continuous fight.
# dummy_one_shot_ignore_tag (default off, mirrors one_shot_ignore_tag for
# players) bypasses the "first-ever hit" gate entirely - every lethal hit
# announces as a one-shot, not just a fresh-encounter kill.
execute unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_one_shot:1b} if data storage scdi:config {dummy_one_shot_ignore_tag:1b} if score $mortal_lethal scdi_const matches 1 run function scdi:spawn_dummy_one_shot_display
execute unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_one_shot:1b} unless data storage scdi:config {dummy_one_shot_ignore_tag:1b} unless score @s scdi_dummy_hit matches 1.. if score $mortal_lethal scdi_const matches 1 run function scdi:spawn_dummy_one_shot_display
# chat fallback alongside the floating display - not "instead of", so it
# still shows even for players who can't see the text_display for whatever
# reason (rendering, distance, etc).
execute unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_one_shot:1b} if data storage scdi:config {dummy_one_shot_ignore_tag:1b} if score $mortal_lethal scdi_const matches 1 run function scdi:announce_dummy_one_shot with storage scdi:tmp26
execute unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_one_shot:1b} unless data storage scdi:config {dummy_one_shot_ignore_tag:1b} unless score @s scdi_dummy_hit matches 1.. if score $mortal_lethal scdi_const matches 1 run function scdi:announce_dummy_one_shot with storage scdi:tmp26
scoreboard players set @s scdi_dummy_hit 1

# passive regen (dummy_regen_tick.mcfunction) only kicks in once this many
# ticks have passed without a hit - every hit, lethal or not, resets that
# clock back to now.
scoreboard players operation @s scdi_dummy_last_hit = $ticks scdi_const

# lethal hit: normally drops whatever's currently equipped as real item
# entities and removes the dummy - a plain mannequin has no loot table of
# its own, so without this, dying would just silently discard whatever it
# had on. an invincible dummy (per-dummy toggle, see
# menu/dummy_menu_invincible_on.mcfunction/dummy_menu_show.mcfunction -
# deliberately not a global default) instead checks against its own
# scdi_dummy_invincible_floor, NOT the mortal_lethal flag above - the whole
# point of invincible is that a single big hit (or a sustained combo)
# should never outright kill it either, just eat into the segment pool
# like any other damage.
# simplified from a gradually-depleting segmented pool to an always-heal-
# to-full backstop - a segmented pool still relies on this same synchronous
# "catch it before the game's own death handling" race for EVERY segment,
# so a big enough single hit (a mace smash, especially) could still lose
# that race partway through the pool and kill the dummy for real. always
# jumping straight to the full heal (apply_dummy_invincible_save.mcfunction)
# doesn't eliminate the race (nothing command-only can), but it does mean
# there's only ever ONE kind of recovery to reason about, and the brief
# invulnerability window it can trigger (dummy_cheat_death_invuln, now
# firing on every near-death instead of rarely) gives real protection
# against a rapid follow-up hit re-triggering the race again immediately.
execute at @s if score @s scdi_dummy_invincible matches 1.. if score @s scdi_health <= @s scdi_dummy_invincible_floor run function scdi:apply_dummy_invincible_save

# time-to-kill readout (optional, dummy_announce_time_to_kill, default on):
# how long it took from the hit that took this dummy off full health
# (scdi_dummy_encounter_start_tick - the same "fresh encounter" marker DPS
# tracking already resets, see apply_check_dummy_hit.mcfunction) to this
# lethal hit. computed as whole seconds + hundredths ($twenty/$five are
# shared scratch constants set once in load.mcfunction) since ticks alone
# aren't a meaningful unit to show a player. hundredths, not tenths - a
# single tick is exactly 1/20s = 0.05s, so (ticks-within-the-second) * 5
# lands on an exact hundredths value (0, 5, 10, ..., 95) with no rounding
# loss, whereas the old tenths math truncated on odd tick counts. this is
# as fine-grained as a 20-tick server can measure - true milliseconds
# aren't observable, only whole ticks (50ms each) are.
execute if score $mortal_lethal scdi_const matches 1 unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_time_to_kill:1b} run scoreboard players operation $ttk_ticks scdi_const = $ticks scdi_const
execute if score $mortal_lethal scdi_const matches 1 unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_time_to_kill:1b} run scoreboard players operation $ttk_ticks scdi_const -= @s scdi_dummy_encounter_start_tick
execute if score $mortal_lethal scdi_const matches 1 unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_time_to_kill:1b} run scoreboard players operation $ttk_whole scdi_const = $ttk_ticks scdi_const
execute if score $mortal_lethal scdi_const matches 1 unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_time_to_kill:1b} run scoreboard players operation $ttk_whole scdi_const /= $twenty scdi_const
execute if score $mortal_lethal scdi_const matches 1 unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_time_to_kill:1b} run scoreboard players operation $ttk_hundredths scdi_const = $ttk_ticks scdi_const
execute if score $mortal_lethal scdi_const matches 1 unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_time_to_kill:1b} run scoreboard players operation $ttk_hundredths scdi_const %= $twenty scdi_const
execute if score $mortal_lethal scdi_const matches 1 unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_time_to_kill:1b} run scoreboard players operation $ttk_hundredths scdi_const *= $five scdi_const
execute if score $mortal_lethal scdi_const matches 1 unless score @s scdi_dummy_invincible matches 1.. if data storage scdi:config {dummy_announce_time_to_kill:1b} run function scdi:announce_dummy_ttk with storage scdi:tmp26

execute at @s if score $mortal_lethal scdi_const matches 1 unless score @s scdi_dummy_invincible matches 1.. run function scdi:apply_drop_dummy_armor
