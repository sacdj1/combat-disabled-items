# called with {threshold:N,one_shot_dmg:N} still as+at the dummy, from
# apply_check_dummy_hit.mcfunction. checked and acted on synchronously in
# the SAME damage-processing step as the hit itself (advancement rewards
# fire as a direct reaction to the damage already being applied), so this
# already runs before the entity's own tick-based death handling gets a
# chance to act. both threshold/one_shot_dmg are for MORTAL dummies only -
# an invincible dummy uses a completely separate check against
# scdi_dummy_invincible_floor instead - see below.
#
# a mortal dummy is lethal-hit by EITHER of two independent conditions,
# combined into one flag so both the one-shot announcement and the actual
# drop-on-death below only need to check it once:
#  - scdi_health <= threshold (dummy_death_threshold, default 20): worn
#    down by cumulative damage to its last normal-player-sized stretch of
#    its (large) pool - a realistic "sustained fight" kill.
#  - scdi_dummy_dmg (this ONE hit's damage, tenths) >= one_shot_dmg
#    (dummy_one_shot_damage, default 20 real HP = 200 tenths): the dummy
#    is meant to act as a player replacement, so any single hit that would
#    have one-shot a real 20-health player has to kill the dummy outright
#    too, regardless of how much of the big pool is left - otherwise a
#    weapon that reliably one-shots a real player would barely dent a
#    1000-health dummy and this whole thing stops being a useful test for
#    "does this one-shot a player".
scoreboard players set $mortal_lethal scdi_const 0
$execute if score @s scdi_health matches ..$(threshold) run scoreboard players set $mortal_lethal scdi_const 1
$execute if score @s scdi_dummy_dmg matches $(one_shot_dmg).. run scoreboard players set $mortal_lethal scdi_const 1

# debugging aid (debug_hit_messages, default off) - shows the exact values
# this file's lethal-hit decision is based on.
$execute if data storage scdi:config {debug_hit_messages:1b} run tellraw @a [{"text":"[hit-dbg] apply_check_dummy_hit2 - scdi_health(score)=","color":"gray"},{"score":{"name":"@s","objective":"scdi_health"}},{"text":" threshold=$(threshold) dmg(tenths)=","color":"gray"},{"score":{"name":"@s","objective":"scdi_dummy_dmg"}},{"text":" one_shot_dmg(tenths)=$(one_shot_dmg) mortal_lethal=","color":"gray"},{"score":{"name":"$mortal_lethal","objective":"scdi_const"}},{"text":" invincible=","color":"gray"},{"score":{"name":"@s","objective":"scdi_dummy_invincible"}}]

# one-shot announcement (optional, dummy_announce_one_shot, default on):
# fires only on the dummy's first-ever hit (scdi_dummy_hit unset, meaning it
# was still at full/spawn health going into this specific hit) if this hit
# alone was lethal by either condition above - the clearest available
# signal of a genuine one-shot, mirroring check_one_shot.mcfunction's logic
# for players. dummy_one_shot_ignore_tag (default off, mirrors
# one_shot_ignore_tag for players) bypasses the "first-ever hit" gate
# entirely - every lethal hit announces as a one-shot, not just a
# fresh-encounter kill.
execute if data storage scdi:config {dummy_announce_one_shot:1b} if data storage scdi:config {dummy_one_shot_ignore_tag:1b} if score $mortal_lethal scdi_const matches 1 run function scdi:spawn_dummy_one_shot_display
execute if data storage scdi:config {dummy_announce_one_shot:1b} unless data storage scdi:config {dummy_one_shot_ignore_tag:1b} unless score @s scdi_dummy_hit matches 1.. if score $mortal_lethal scdi_const matches 1 run function scdi:spawn_dummy_one_shot_display
# chat fallback alongside the floating display - not "instead of", so it
# still shows even for players who can't see the text_display for whatever
# reason (rendering, distance, etc).
execute if data storage scdi:config {dummy_announce_one_shot:1b} if data storage scdi:config {dummy_one_shot_ignore_tag:1b} if score $mortal_lethal scdi_const matches 1 run tellraw @a {"text":"⚔ Dummy was ONE-SHOT!","color":"red","bold":true}
execute if data storage scdi:config {dummy_announce_one_shot:1b} unless data storage scdi:config {dummy_one_shot_ignore_tag:1b} unless score @s scdi_dummy_hit matches 1.. if score $mortal_lethal scdi_const matches 1 run tellraw @a {"text":"⚔ Dummy was ONE-SHOT!","color":"red","bold":true}
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
# point of invincible is that a single big hit should never outright kill
# it either, just eat into the segment pool like any other damage.
execute at @s if score @s scdi_dummy_invincible matches 1.. if score @s scdi_health <= @s scdi_dummy_invincible_floor run function scdi:apply_dummy_invincible_segment_check
execute at @s if score $mortal_lethal scdi_const matches 1 unless score @s scdi_dummy_invincible matches 1.. run function scdi:apply_drop_dummy_armor
