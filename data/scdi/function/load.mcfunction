# run every time the datapack (re)loads
scoreboard objectives add scdi_tag dummy
scoreboard objectives add scdi_id dummy
scoreboard objectives add scdi_elapsed dummy
scoreboard objectives add scdi_sec dummy
scoreboard objectives add scdi_pct dummy
scoreboard objectives add scdi_flash dummy
scoreboard objectives add scdi_health dummy
scoreboard objectives add scdi_const dummy
scoreboard objectives add scdi_deaths deathCount
scoreboard objectives add scdi_last_deaths dummy
scoreboard objectives add scdi_team dummy
# friendly label if show_team_on_tab (see further down) puts this on the
# tab list display slot - harmless no-op otherwise, same as scdi_sec's
# displayname for below_name.
scoreboard objectives modify scdi_team displayname {"text":"Team","color":"aqua"}
# global-tick timestamp of the last time combat ended for this player - see
# check_one_shot.mcfunction / one_shot_cooldown_enabled below.
scoreboard objectives add scdi_last_combat_end_tick dummy
# set on a player when someone else requests to team up with them (see
# team_request_trigger.mcfunction) - holds the requester's scdi_id until
# /trigger ScdiTeamConfirm resolves it (or a later request overwrites it).
scoreboard objectives add scdi_team_requested_by_id dummy
# global-tick timestamp of when the pending request above was sent - lets
# team_request_expiry_tick.mcfunction tell a stale request apart from a
# fresh one and expire it automatically (see team_request_timeout below).
scoreboard objectives add scdi_team_request_tick dummy
scoreboard objectives add scdi_untaggable dummy
# scaled squared horizontal motion magnitude, recomputed every tick a player
# is online while proximity_role_by_movement is on (see
# apply_compute_proximity_movement.mcfunction/check_proximity_role_movement.mcfunction) -
# only ever compared against ANOTHER player's own value on the same tick to
# decide who's moving more, never read as an absolute/real-world quantity,
# so the arbitrary scale/squaring doesn't matter.
scoreboard objectives add scdi_movement dummy
# set the first time armor actually gets disabled/disguised in a fresh
# encounter (see check_armor_warning.mcfunction/disguise_armor_warning
# below) - reset at combat_end so the warning can show again next
# encounter, not spammed on every single armor-slot nullify within the
# same one.
scoreboard objectives add scdi_armor_warning_shown dummy
# same idea for the inventory-icon warning (see check_inventory_warning.mcfunction/
# disguise_inventory_warning further down).
scoreboard objectives add scdi_inventory_warning_shown dummy
# whether @s has taken at least one player hit yet in the current
# encounter - reset at combat_end alongside the two warning-shown flags
# above, same "fresh encounter" boundary. deliberately separate from
# scdi_tag (see check_one_shot.mcfunction) - scdi_tag can be 1 for reasons
# unrelated to actually having been hit as a victim (proximity tagging,
# being tagged as an attacker elsewhere, a lingering retag), so it alone
# can't reliably answer "was this really the first hit that's landed on
# them", the actual question a one-shot kill needs answered. without this,
# one_shot_ignore_tag (which bypasses the scdi_tag-based gate on purpose)
# had nothing left verifying single-hit-ness at all, so EVERY kill -
# regardless of how many hits it actually took - announced as a "one
# shot", not just fresh-encounter ones.
scoreboard objectives add scdi_one_shot_hit dummy
# holds a target $ticks value (scdi_const) for the armor/inventory warning
# SOUND specifically (not the chat message, which still fires immediately) -
# the disguise swap itself plays the item's own equip_sound
# (disguise_armor_equip_sound) at the exact same moment the warning would
# normally fire, and that equip sound can drown out/mask the quieter
# warning sound if both play in the same tick. delaying just the sound a
# short beat (see check_armor_warning.mcfunction/check_inventory_warning.mcfunction,
# fired from tick.mcfunction) lets the equip sound finish first. unset
# (reset) once fired - "matches 0.." is how tick.mcfunction knows one is
# pending, same unset-vs-set convention used everywhere else in this pack.
scoreboard objectives add scdi_armor_warning_sound_at dummy
scoreboard objectives add scdi_inventory_warning_sound_at dummy
# set on the floating text_display entity itself (see
# spawn_timer_display.mcfunction), matching its owning player's scdi_id -
# real ownership tracking, since proximity-based "nearest display" lookups
# break in multiplayer when two tagged players end up near each other.
scoreboard objectives add scdi_owner_id dummy
# set on a test dummy the first time it's ever hit (see
# apply_check_dummy_hit.mcfunction) - lets that function tell "first
# hit ever" apart from a later hit, the same way scdi_tag distinguishes a
# player's first hit from a retag.
scoreboard objectives add scdi_dummy_hit dummy
# global-tick timestamp of the last time a dummy took damage (see
# apply_check_dummy_hit.mcfunction) - passive regen (dummy_regen_tick.mcfunction)
# only heals once enough ticks have passed since this.
scoreboard objectives add scdi_dummy_last_hit dummy
# unique per-dummy id (see configure_new_dummy.mcfunction), matched against
# scdi_owner_id on each of its displays (health/one-shot/tag) so they can
# actively track its position every tick instead of guessing "nearest
# dummy" - needed now that a dummy can actually move (knockback, unless
# dummy_immobile is on).
scoreboard objectives add scdi_dummy_id dummy
# per-hit damage dealt to a dummy, in TENTHS of a health point (so small
# hits under 1 full HP still register instead of rounding away to 0), used
# for the RPG-style floating "-N.n" popup
# (spawn_dummy_damage_display.mcfunction) and folded into scdi_dummy_total_dmg
# below for DPS tracking (also in tenths).
scoreboard objectives add scdi_dummy_dmg dummy
# health reading at *10 scale, purely for the damage-delta math above - kept
# separate from scdi_health (scale 1) so changing one's precision never
# affects the other.
scoreboard objectives add scdi_dummy_health_fine dummy
# a MORTAL dummy's real death gate - a simulated player-sized health pool
# (tenths scale, capped at dummy_one_shot_damage*10), tracked entirely
# separately from the large safety-buffer pool (dummy_max_health). drains
# by the same amount as every hit, regenerates on the same passive-regen
# schedule, dies at 0 - see apply_check_dummy_hit.mcfunction/
# apply_check_dummy_hit2.mcfunction/apply_dummy_regen_heal.mcfunction. an
# invincible dummy still tracks this (so it picks up where it left off if
# ever made mortal again) but never lets it gate death - that dummy uses
# its own separate scdi_dummy_invincible_floor segment system instead.
scoreboard objectives add scdi_dummy_sim_hp dummy
# running damage total for the CURRENT encounter (since the dummy was last
# at full health) and the global tick it started - together these drive
# the DPS readout on the health display (see
# apply_update_dummy_health_display.mcfunction/apply_check_dummy_hit.mcfunction).
scoreboard objectives add scdi_dummy_total_dmg dummy
scoreboard objectives add scdi_dummy_encounter_start_tick dummy
# per-dummy invincibility toggle (see menu/dummy_menu_invincible_on.mcfunction/
# _off.mcfunction and apply_check_dummy_hit2.mcfunction) - dummy_invincible_default
# further down seeds new dummies with a starting value, same as most other
# per-dummy settings; still independently adjustable afterward via the
# dummy management menu regardless of what it spawned with.
scoreboard objectives add scdi_dummy_invincible dummy
# the raw-health trigger point for an invincible dummy's NEXT "cheated
# death" - always (dummy_max_health - 20), reset back to that same value
# every time it's crossed (apply_dummy_invincible_save.mcfunction heals
# straight back to full and resets this), so any 20+ damage triggers a
# full heal-back rather than gradually draining a large pool across many
# hits (an earlier segmented version of this still relied on the same
# synchronous "catch it before death" race for every segment, so a single
# big enough hit - a mace smash, especially - could still lose that race
# partway through the pool). see apply_compute_dummy_display_health.mcfunction
# for how this turns into a "looks like a normal player's health bar" 0-20
# display value instead of the raw pool number.
scoreboard objectives add scdi_dummy_invincible_floor dummy
# global-tick timestamp: a dummy won't pick items back up
# (dummy_pickup_tick.mcfunction) until $ticks reaches this - set whenever it
# drops its own items (apply_drop_all_dummy_items.mcfunction) so it doesn't
# immediately re-equip the exact items it was just made to throw away.
scoreboard objectives add scdi_dummy_pickup_cooldown_until dummy
# per-dummy "pin in place" toggle (see menu/dummy_menu_pin_on.mcfunction/
# _off.mcfunction, dummy_menu_show.mcfunction) - a strictly stronger form
# of immobility than dummy_immobile/knockback_resistance, which only
# dampens COMBAT knockback and does nothing against pistons, water/lava
# currents, or any other physical displacement. a pinned dummy gets
# teleported back to its exact captured position every tick
# (apply_dummy_pin_tick.mcfunction), unconditionally overriding anything
# that moved it that tick. position captured at *1000 scale (three decimal
# places) for sub-block precision, same trick already used for the
# throw-direction marker in apply_drop_all_dummy_items.mcfunction.
scoreboard objectives add scdi_dummy_pinned dummy
scoreboard objectives add scdi_dummy_pin_x dummy
scoreboard objectives add scdi_dummy_pin_y dummy
scoreboard objectives add scdi_dummy_pin_z dummy
# global-tick timestamp set on a one-off "ONE SHOT" display at spawn (see
# apply_configure_dummy_one_shot_display.mcfunction) so the expiry sweep in
# tick.mcfunction knows how long it's existed.
scoreboard objectives add scdi_display_spawn_tick dummy
scoreboard objectives add scdi_item_dur dummy
scoreboard objectives add scdi_item_sec dummy
# which red/yellow flash phase a tagged player's disguised armor was last
# repainted to - only used by the OPTIONAL disguise_armor_recolor feature
# (off by default, see apply_disguise_armor_flash_recolor_check.mcfunction),
# not the always-on particle flash which needs no per-player state at all.
scoreboard objectives add scdi_armor_flash_phase dummy
# a dummy's OWN combat-lock state (dummy_combat_simulation) - independent
# of scdi_dummy_hit (the DPS/one-shot "fresh encounter" tracker) and
# scdi_tag (a real PLAYER's own lock). scdi_dummy_elapsed holds the result
# of querying the dummy's own real-time /stopwatch (see
# create_dummy_stopwatch.mcfunction/query_dummy_stopwatch.mcfunction) -
# real milliseconds, same units/mechanism a real player's own combat lock
# uses via scdi_elapsed, not an approximation from the tick counter.
scoreboard objectives add scdi_dummy_tag dummy
scoreboard objectives add scdi_dummy_elapsed dummy
# self-extinguish sequence state (see
# apply_dummy_start_extinguish.mcfunction/apply_dummy_finish_extinguish.mcfunction) -
# scdi_dummy_extinguishing is the busy flag that suppresses look-at-player
# for the duration and stops the sequence retriggering mid-animation.
# extinguish_y_offset records WHICH spot got the water (0 = feet, 1 =
# head, see the feet-then-head fallback in
# apply_dummy_start_extinguish.mcfunction) so removal targets the same
# spot relative to the dummy again, rather than storing absolute
# coordinates - dummies are immobile by default (dummy_immobile) so this
# is a fine simplification for the vast majority of cases, and even if a
# non-immobile one drifts slightly during the brief window, at worst a
# stray water block gets left behind rather than anything breaking.
scoreboard objectives add scdi_dummy_extinguishing dummy
scoreboard objectives add scdi_dummy_extinguish_until dummy
scoreboard objectives add scdi_dummy_extinguish_y_offset dummy
# per-dummy versions of what were originally global toggles
# (dummy_combat_simulation/dummy_extinguish_in_combat/
# dummy_extinguish_on_cheat_death/dummy_cheat_death_invulnerability) -
# each dummy now has its OWN independent state for these, toggleable via
# the dummy trigger menu same as invincible/pinned/immobile already are.
# the matching config keys still exist, but now mean "what a NEWLY
# SPAWNED dummy starts with" (see configure_new_dummy.mcfunction), not
# "on/off for every dummy at once" - same relationship dummy_immobile
# already has with the per-dummy knockback_resistance attribute.
scoreboard objectives add scdi_dummy_combat_simulation dummy
scoreboard objectives add scdi_dummy_extinguish_in_combat dummy
scoreboard objectives add scdi_dummy_extinguish_on_cheat_death dummy
scoreboard objectives add scdi_dummy_cheat_death_invuln dummy
# same per-dummy/global-default relationship as the four above, for
# whether THIS dummy passively regenerates health when undamaged (dummy_regen
# - see load.mcfunction's dummy_regen comment further down and
# dummy_regen_tick.mcfunction).
scoreboard objectives add scdi_dummy_regen dummy
# same per-dummy/global-default relationship, for whether THIS dummy's
# cheat-death totem "pop" sound (apply_dummy_invincible_save.mcfunction)
# plays - independent of the allay hum below, so either/both/neither can
# be on. the particle burst is unaffected by either.
scoreboard objectives add scdi_dummy_cheat_death_sound_totem dummy
# same idea for the allay hum, independent of the totem pop above.
scoreboard objectives add scdi_dummy_cheat_death_sound_allay dummy
# "trigger" type, not dummy - lets any player (no op needed) fire /help and
# /menu via /trigger, since plain /function requires permission level 2. see
# tick.mcfunction for the dispatch/reset logic.
scoreboard objectives add ScdiHelp trigger
scoreboard objectives add ScdiMenu trigger
scoreboard objectives add ScdiDummy trigger
scoreboard objectives add ScdiDummyMenu trigger
# page 2 of the dummy trigger menu (dummy_menu2_show.mcfunction) - the
# combat-simulation/self-extinguish/cheat-death-invuln/regen toggles moved
# here once page 1 got too crowded to read comfortably. reachable either by
# clicking [Next page ->] on page 1, or directly via "/trigger
# ScdiDummyMenu2" on its own, same public/allow_dummy_trigger-gated pattern
# as ScdiDummyMenu.
scoreboard objectives add ScdiDummyMenu2 trigger
scoreboard objectives add ScdiTeamRequest trigger
scoreboard objectives add ScdiTeamConfirm trigger
scoreboard objectives add ScdiTeamReset trigger
# a single shared trigger for every button inside the dummy-management menu
# (dummy_menu_show.mcfunction) - see dummy_menu_action_dispatch.mcfunction
# for the full story. "/trigger X" is permission-level 0 (any player can
# run it) but "/function scdi:..." is level 2 (operator-only) EVEN when
# fired via a clickable chat button - a non-op player clicking any of those
# buttons was silently failing with a permission error, never reaching the
# function's own internal allow_dummy_trigger check at all. every button
# now runs "/trigger ScdiDummyAction set N" instead (always allowed), and
# the tick loop (running with full server permissions) does the actual
# /function call on their behalf, exactly like the ScdiDummy/ScdiDummyMenu
# triggers already do for the menu's entry points.
scoreboard objectives add ScdiDummyAction trigger

# per-player self-service settings (own preferences only, unlike the
# op-only /menu) - "My Settings" (player_menu_show.mcfunction), reached via
# /trigger ScdiPlayerMenu, any player, no gate needed since it only ever
# touches their own scores. ScdiPlayerMenuAction is the button-click
# dispatch, same "/trigger X set N" + tick-loop-dispatches-with-full-perms
# pattern as ScdiDummyAction.
scoreboard objectives add ScdiPlayerMenu trigger
scoreboard objectives add ScdiPlayerMenuAction trigger
# per-player override of disguise_armor_warning (see below) - whether
# checkarmor_warning.mcfunction actually shows the "may not render" chat
# warning to THIS specific player. lazily initialized from the global
# default the first time it's ever read for a player who hasn't set their
# own preference yet (see check_armor_warning.mcfunction) rather than a
# tick-loop default, since it only matters at the one moment it's read.
scoreboard objectives add scdi_armor_warning_pref dummy
# per-player override of disguise_armor_warning_sound (see below) - whether
# the armor-disabled warning also plays a sound for THIS player.
scoreboard objectives add scdi_armor_warning_sound_pref dummy
# same per-player-override relationship for disguise_inventory_warning (see
# below) - see check_inventory_warning.mcfunction.
scoreboard objectives add scdi_inventory_warning_pref dummy
scoreboard objectives add scdi_inventory_warning_sound_pref dummy

# label shown next to the number if show_timer_above_head displays this
# objective below players' nametags (see further down) - harmless no-op
# otherwise. kept to just "s" (not "s in combat") since belowname always
# renders "<score> <displayname>" with one space in between that can't be
# removed - it's an engine-level separator, not something a text component
# can close up - so the shorter the displayname, the tighter "7 s" reads.
# just a starting default here - combat_active.mcfunction actively re-modifies
# this same displayname's color every tick, for whoever's currently tagged,
# to fade through the same phases as the actionbar/floating-display timers
# (this line only matters before anyone's ever been tagged since load). "modify
# displayname" (unlike "add") is safe to re-run every load, so this always
# stays current even though the objective itself is only actually created once.
scoreboard objectives modify scdi_sec displayname {"text":"s","color":"gold"}

# these constants only get their default the very first time the pack ever
# loads in a world - once set (by default or by hand), reloading never
# resets them, so live adjustments always stick

# counter used to hand out a unique /stopwatch id to each player - must never
# reset on reload or two players could end up sharing the same stopwatch id
execute unless score $next_id scdi_const matches -2147483648..2147483647 run scoreboard players set $next_id scdi_const 0

# same idea as $next_id above, but for dummies (scdi_dummy_id) - a separate
# counter/namespace so the two never collide, even though nothing actually
# cross-references them against each other.
execute unless score $next_dummy_id scdi_const matches -2147483648..2147483647 run scoreboard players set $next_dummy_id scdi_const 0

# combat lock duration in real milliseconds (/stopwatch measures wall-clock
# time, not game ticks). change this any time, it applies to every player
# instantly and survives reloads:
#   /scoreboard players set $duration scdi_const <milliseconds>
execute unless score $duration scdi_const matches -2147483648..2147483647 run scoreboard players set $duration scdi_const 10000

# internal constants (not user-facing) used for the actionbar display math -
# always force these, unlike the values above, so a stale value from an older
# version of this pack can never stick around
scoreboard players set $div scdi_const 1000
scoreboard players set $ceil_offset scdi_const 999
scoreboard players set $hundred scdi_const 100
scoreboard players set $flash_div scdi_const 100
scoreboard players set $two scdi_const 2
scoreboard players set $four scdi_const 4
scoreboard players set $twenty scdi_const 20
scoreboard players set $ten scdi_const 10
scoreboard players set $five scdi_const 5
# for unpacking a 24-bit packed RGB color int (see
# apply_compute_flash_color_floats.mcfunction) - base-256 positional
# encoding, color = R*65536 + G*256 + B.
scoreboard players set $rgb_65536 scdi_const 65536
scoreboard players set $rgb_256 scdi_const 256

# item a nullified rocket actually becomes while locked out (must be a real,
# non-placeable-preferred item id; a stick by default so there's nothing to
# place at all). change it any time, it applies instantly and survives reloads:
#   /data modify storage scdi:config disguise_item set value "minecraft:stick"
execute unless data storage scdi:config disguise_item run data modify storage scdi:config disguise_item set value "minecraft:stick"

# what that disguised item LOOKS like (minecraft:item_model component - purely
# visual, doesn't change the item's real type/behavior at all). change it any
# time, it applies instantly and survives reloads:
#   /data modify storage scdi:config disguise_model set value "minecraft:barrier"
execute unless data storage scdi:config disguise_model run data modify storage scdi:config disguise_model set value "minecraft:barrier"

# what the disguised item looks like WHEN WORN in an armor slot (elytra, or
# any custom item rule targeting head/chest/legs/feet) - a completely
# separate thing from disguise_model above. disguise_model only controls
# minecraft:item_model (the 2D icon/held appearance); the armor-slot
# equipment renderer instead reads minecraft:equippable's asset_id field
# specifically, and if that's missing entirely - which it always was before
# this setting existed - the disguised item renders as literally NOTHING on
# the player's body while worn (confirmed via Minecraft's own docs: an
# equippable item with no asset_id "does not render" in a non-head slot).
# must be a real equipment asset id (assets/<ns>/equipment/<id>.json) - an
# arbitrary item id like disguise_model uses won't work here, vanilla armor
# material names like "leather"/"iron"/"diamond" etc. are the built-in
# options. defaults to leather (plain, dyeable, valid for all 4 slots).
# change it any time, it applies instantly and survives reloads:
#   /data modify storage scdi:config disguise_armor_model set value "minecraft:leather"
execute unless data storage scdi:config disguise_armor_model run data modify storage scdi:config disguise_armor_model set value "minecraft:leather"

# whether currently-disguised armor gets red/yellow dust particles flashing
# around it while worn (the worn model itself is a fixed red tint - see
# apply_nullify_armor.mcfunction for why it's not repainted repeatedly),
# same idea as the "(Tagged!)" actionbar flash - a clear, unmissable "this
# is disabled" signal, not just in your own UI. particles never touch the
# armor's own data, so unlike an earlier version of this feature there's no
# equip-sound risk. on by default. change any time, survives reloads:
#   /data modify storage scdi:config disguise_armor_flash set value 1b   (on, default)
#   /data modify storage scdi:config disguise_armor_flash set value 0b   (off)
execute unless data storage scdi:config disguise_armor_flash run data modify storage scdi:config disguise_armor_flash set value 1b

# how many ticks (20 = 1 second) each flash color phase lasts - default 6
# (0.3s per phase). cycle is color A/color B/color A/color A (see
# apply_disguise_armor_flash_check.mcfunction), so a full cycle is 4x this
# value. only matters if disguise_armor_flash is on. change any time,
# survives reloads:
#   /data modify storage scdi:config disguise_armor_flash_interval set value 6
execute unless data storage scdi:config disguise_armor_flash_interval run data modify storage scdi:config disguise_armor_flash_interval set value 6

# the two colors the flash cycles between (packed 24-bit RGB int, same
# representation minecraft:dyed_color/leather armor dye already uses - e.g.
# 16711680 = pure red, 16776960 = pure yellow) - color_a is the "3x as
# common" phase (see apply_disguise_armor_flash_check.mcfunction's
# red/yellow/red/red cycle), color_b is the "1x" phase. feeds BOTH the
# particle flash (apply_compute_flash_color_floats.mcfunction unpacks this
# into 0.0-1.0 RGB floats for the particle command - dust particles want
# floats, dyed_color wants the packed int directly) and, if
# disguise_armor_recolor is on, the actual armor repaint - one shared color
# pair instead of two separately hardcoded ones. defaults: red/yellow.
# change any time, survives reloads:
#   /data modify storage scdi:config disguise_armor_flash_color_a set value 16711680
#   /data modify storage scdi:config disguise_armor_flash_color_b set value 16776960
execute unless data storage scdi:config disguise_armor_flash_color_a run data modify storage scdi:config disguise_armor_flash_color_a set value 16711680
execute unless data storage scdi:config disguise_armor_flash_color_b run data modify storage scdi:config disguise_armor_flash_color_b set value 16776960

# whether the worn armor ITSELF also gets recolored on every flash phase
# (on top of the particles above), not just tinted once and left alone.
# off by default, opt-in - every attempt to make this silent failed
# (equip_sound has no volume control, and no real vanilla sound is silent
# by nature - see apply_nullify_armor.mcfunction's history of this), so
# turning this on means accepting a sound plays on every color change.
# disguise_armor_equip_sound below at least lets you pick something less
# jarring than the default armor clink. change any time, survives reloads:
#   /data modify storage scdi:config disguise_armor_recolor set value 1b   (armor itself repaints too, will make noise)
#   /data modify storage scdi:config disguise_armor_recolor set value 0b   (particles only, silent, default)
execute unless data storage scdi:config disguise_armor_recolor run data modify storage scdi:config disguise_armor_recolor set value 0b

# which sound plays on the disguised armor's equip events - the very first
# swap always makes ONE sound no matter what (same as any other equip,
# expected/normal), and if disguise_armor_recolor above is also on, this
# plays again on every repaint too. defaults to a soft candle-extinguish
# puff - about as quiet as a vanilla sound event gets - rather than the
# default armor clink. change any time, survives reloads:
#   /data modify storage scdi:config disguise_armor_equip_sound set value "minecraft:block.candle.extinguish"
execute unless data storage scdi:config disguise_armor_equip_sound run data modify storage scdi:config disguise_armor_equip_sound set value "minecraft:block.candle.extinguish"

# DEFAULT a newly-seen player's own preference starts with for a
# one-time-per-encounter "your armor has been disabled" chat warning
# (scdi_armor_warning_pref, toggleable per-player via /trigger
# ScdiPlayerMenu - see player_menu_show.mcfunction/check_armor_warning.mcfunction) -
# same "global default, per-instance live override" relationship the dummy
# settings use. fires the moment any worn armor actually gets disguised.
# an earlier version of this warned specifically about the worn MODEL
# possibly not rendering (disguise_armor_model/disguise_model can be set
# to a resource-pack-only asset) - replaced with this simpler general
# notice per user request; keeping the note here in case that more
# specific framing is wanted back later. default: on. change any time,
# survives reloads:
#   /data modify storage scdi:config disguise_armor_warning set value 1b   (new players start with the warning on, default)
#   /data modify storage scdi:config disguise_armor_warning set value 0b   (new players start with it off)
execute unless data storage scdi:config disguise_armor_warning run data modify storage scdi:config disguise_armor_warning set value 1b

# same default relationship for whether the armor-disabled warning above
# also plays a sound (combat_sound/combat_pitch/combat_volume - same sound
# already used for the tag-start signal) - a separate per-player
# preference (scdi_armor_warning_sound_pref) from the message itself, off
# by default. change any time, survives reloads:
#   /data modify storage scdi:config disguise_armor_warning_sound set value 1b   (new players start with the sound on)
#   /data modify storage scdi:config disguise_armor_warning_sound set value 0b   (new players start with it off, default)
execute unless data storage scdi:config disguise_armor_warning_sound run data modify storage scdi:config disguise_armor_warning_sound set value 0b

# which sound actually plays for the armor warning above, if its sound
# preference is on - a dedicated pick separate from combat_sound (uses
# combat_pitch/combat_volume still, just a different sound event id), so
# it can be tuned to stand out from the tag-start signal. only ever played
# to the one player who triggered the warning (playsound ... master @s,
# see play_armor_warning_sound.mcfunction), never broadcast. change any
# time, survives reloads:
#   /data modify storage scdi:config disguise_armor_warning_sound_id set value "minecraft:block.note_block.bit"
execute unless data storage scdi:config disguise_armor_warning_sound_id run data modify storage scdi:config disguise_armor_warning_sound_id set value "minecraft:block.note_block.bit"

# same idea as disguise_armor_warning above, but for a disguised item
# sitting in a regular inventory/hotbar/mainhand/offhand slot (firework
# rocket, wind charge, elytra in your backpack, or any mainhand/offhand
# custom item rule) rather than worn armor. off by default, unlike the
# armor one. also a per-player preference from here on
# (scdi_inventory_warning_pref, /trigger ScdiPlayerMenu - see
# check_inventory_warning.mcfunction) - this is only the starting point
# for a player never seen before. earlier version warned specifically
# about the item's ICON possibly not rendering (item_model resource-pack
# dependency) - replaced with the same simpler general notice as the
# armor one, per user request; note kept here in case that framing is
# wanted back later. change any time, survives reloads:
#   /data modify storage scdi:config disguise_inventory_warning set value 1b   (new players start with the warning on)
#   /data modify storage scdi:config disguise_inventory_warning set value 0b   (new players start with it off, default)
execute unless data storage scdi:config disguise_inventory_warning run data modify storage scdi:config disguise_inventory_warning set value 0b

# same sound-preference relationship as disguise_armor_warning_sound
# above, for the inventory warning. change any time, survives reloads:
#   /data modify storage scdi:config disguise_inventory_warning_sound set value 1b   (new players start with the sound on)
#   /data modify storage scdi:config disguise_inventory_warning_sound set value 0b   (new players start with it off, default)
execute unless data storage scdi:config disguise_inventory_warning_sound run data modify storage scdi:config disguise_inventory_warning_sound set value 0b

# same idea as disguise_armor_warning_sound_id above, for the inventory
# warning - own dedicated sound pick, still only ever played to the one
# player who triggered it. change any time, survives reloads:
#   /data modify storage scdi:config disguise_inventory_warning_sound_id set value "minecraft:block.note_block.bit"
execute unless data storage scdi:config disguise_inventory_warning_sound_id run data modify storage scdi:config disguise_inventory_warning_sound_id set value "minecraft:block.note_block.bit"

# the display name shown on the disguised item (minecraft:custom_name
# component - purely cosmetic). change it any time, it applies instantly and
# survives reloads:
#   /data modify storage scdi:config disguise_name set value "Items Disabled!"
execute unless data storage scdi:config disguise_name run data modify storage scdi:config disguise_name set value "Items Disabled!"

# color/bold/italic for that display name. default: red, bold, not italic.
# change any time, survives reloads:
#   /data modify storage scdi:config disguise_name_color set value "red"
#   /data modify storage scdi:config disguise_name_bold set value 1b
#   /data modify storage scdi:config disguise_name_italic set value 1b
execute unless data storage scdi:config disguise_name_color run data modify storage scdi:config disguise_name_color set value "red"
execute unless data storage scdi:config disguise_name_bold run data modify storage scdi:config disguise_name_bold set value 1b
execute unless data storage scdi:config disguise_name_italic run data modify storage scdi:config disguise_name_italic set value 0b

# whether the disguised item shows an enchantment glint (purely cosmetic).
# default: on. change any time, survives reloads:
#   /data modify storage scdi:config disguise_glint set value 1b   (glint on, default)
#   /data modify storage scdi:config disguise_glint set value 0b   (glint off)
execute unless data storage scdi:config disguise_glint run data modify storage scdi:config disguise_glint set value 1b

# whether non-player damage (mobs, environment, etc.) also triggers the
# combat lock. default: off, PvP only. change any time, survives reloads:
#   /data modify storage scdi:config pve_mode set value 1b   (also lock on PvE damage)
#   /data modify storage scdi:config pve_mode set value 0b   (PvP only, default)
execute unless data storage scdi:config pve_mode run data modify storage scdi:config pve_mode set value 0b

# whether dying resets the combat lock early. default: off - the timer keeps
# running through death/respawn, so you can't escape the lock by dying.
# change any time, survives reloads:
#   /data modify storage scdi:config reset_on_death set value 1b   (reset on death)
#   /data modify storage scdi:config reset_on_death set value 0b   (keep running, default)
execute unless data storage scdi:config reset_on_death run data modify storage scdi:config reset_on_death set value 0b

# whether getting hit again while ALREADY tagged restarts the combat timer
# back to full, or just lets the existing timer keep counting down. default:
# on - every hit refreshes the lock. change any time, survives reloads:
#   /data modify storage scdi:config retag_resets_timer set value 1b   (every hit refreshes the timer, default)
#   /data modify storage scdi:config retag_resets_timer set value 0b   (only the first hit starts the timer)
execute unless data storage scdi:config retag_resets_timer run data modify storage scdi:config retag_resets_timer set value 1b

# whether the "- fireworks disabled" part of the actionbar text is shown.
# default: on. change any time, survives reloads:
#   /data modify storage scdi:config show_disabled_text set value 1b   (show it, default)
#   /data modify storage scdi:config show_disabled_text set value 0b   (just "In Combat (Ns)")
execute unless data storage scdi:config show_disabled_text run data modify storage scdi:config show_disabled_text set value 1b

# whether the actionbar countdown ("In Combat (Ns)", just above the hotbar)
# shows at all. default: on. off skips it entirely regardless of
# show_disabled_text above - independent of, and can be combined any way
# with, the below_name/floating-text_display nametag options further down
# (e.g. hotbar text off + floating display on, if you only want the
# above-head version and not the actionbar one). change any time, survives
# reloads:
#   /data modify storage scdi:config show_hotbar_text set value 1b   (show it, default)
#   /data modify storage scdi:config show_hotbar_text set value 0b   (off)
execute unless data storage scdi:config show_hotbar_text run data modify storage scdi:config show_hotbar_text set value 1b

# whether the big "In Combat!" title/subtitle shows the instant you're
# tagged. default: on. the actionbar countdown and the sound are unaffected
# by this - it only controls the big center-screen title. change any time,
# survives reloads:
#   /data modify storage scdi:config show_tag_title set value 1b   (show it, default)
#   /data modify storage scdi:config show_tag_title set value 0b   (off)
execute unless data storage scdi:config show_tag_title run data modify storage scdi:config show_tag_title set value 1b

# whether each tagged player's remaining combat time (scdi_sec) is shown
# below their nametag, via vanilla's "below_name" scoreboard display slot -
# so anyone looking at them (not just themselves) can see their countdown.
# optional, off by default. below_name is a single GLOBAL slot shared by the
# whole world - turning this on takes it over entirely for as long as it's
# on. vanilla has no command to QUERY which objective currently occupies a
# display slot, only to set/clear one - so this can't automatically detect
# and restore whatever (if anything) was on below_name before it claims the
# slot. belowname_restore_objective below is the manual workaround: if you
# were already using below_name for something else, put that objective's
# exact name there BEFORE turning this on, and turning it back off (or
# uninstalling) restores that objective instead of just clearing the slot.
# change any time, survives reloads:
#   /data modify storage scdi:config show_timer_above_head set value 1b   (on)
#   /data modify storage scdi:config show_timer_above_head set value 0b   (off, default)
execute unless data storage scdi:config show_timer_above_head run data modify storage scdi:config show_timer_above_head set value 0b
execute if data storage scdi:config {show_timer_above_head:1b} run scoreboard objectives setdisplay below_name scdi_sec

# see show_timer_above_head just above - the objective name to hand
# below_name BACK to once this pack releases the slot (turned off, config
# reset, or uninstalled), instead of just clearing it. empty string
# (default) means "there wasn't a previous one, just clear it" - the
# original, always-clear behavior. any non-empty value here is used as-is
# (a typo'd/non-existent objective name will just make vanilla's own
# setdisplay command fail loudly, same as typing it wrong by hand).
#   /data modify storage scdi:config belowname_restore_objective set value "my_other_objective"
#   /data modify storage scdi:config belowname_restore_objective set value ""   (default - just clear on release)
execute unless data storage scdi:config belowname_restore_objective run data modify storage scdi:config belowname_restore_objective set value ""

# alternative to the above: instead of (or alongside) the below_name slot,
# show a floating minecraft:text_display entity tracking each tagged player,
# well above their nametag rather than tucked right under it - doesn't touch
# any global display slot, so it can't conflict with another datapack/plugin.
# default: on. see spawn_timer_display.mcfunction (spawned once at
# tag-start), apply_update_timer_display.mcfunction (teleports it onto the
# player + rewrites the countdown every tick), and the orphan-cleanup sweep
# in tick.mcfunction (handles a player logging off mid-combat, which would
# otherwise leave it stranded with nothing tracking it). change any time,
# survives reloads:
#   /data modify storage scdi:config show_timer_text_display set value 1b   (on, default)
#   /data modify storage scdi:config show_timer_text_display set value 0b   (off)
execute unless data storage scdi:config show_timer_text_display run data modify storage scdi:config show_timer_text_display set value 1b

# extra safety: also disguise/restore any firework rockets/wind charges/
# elytra/disguised-anything sitting anywhere in the hotbar (slots 0-8), not
# just whichever one is actively held - so moving a nulled item around
# your own hotbar never lets it slip through untracked. separate from
# scan_extended_inventory below (the rest of the backpack, slots 9-35) -
# split apart so hotbar coverage (much more likely to matter, since it's
# where actively-used items - including whatever just got swapped out of
# an armor slot - tend to end up mid-fight) can stay on independently of
# the deeper backpack, e.g. to isolate which one's actually costing
# performance. on by default. change any time, survives reloads:
#   /data modify storage scdi:config scan_hotbar set value 1b   (on, default)
#   /data modify storage scdi:config scan_hotbar set value 0b   (off)
execute unless data storage scdi:config scan_hotbar run data modify storage scdi:config scan_hotbar set value 1b

# same idea as scan_hotbar above, for the rest of the backpack (slots
# 9-35, everything below the hotbar). on by default. change any time,
# survives reloads:
#   /data modify storage scdi:config scan_extended_inventory set value 1b   (on, default)
#   /data modify storage scdi:config scan_extended_inventory set value 0b   (off)
execute unless data storage scdi:config scan_extended_inventory run data modify storage scdi:config scan_extended_inventory set value 1b

# whether firework rockets get disguised/disabled while tagged - this is the
# core point of the pack, so it's on by default, but can be turned off (e.g.
# if you only want the wind charge lock below). change any time, survives
# reloads:
#   /data modify storage scdi:config disable_firework_rocket set value 1b   (default)
#   /data modify storage scdi:config disable_firework_rocket set value 0b   (off)
execute unless data storage scdi:config disable_firework_rocket run data modify storage scdi:config disable_firework_rocket set value 1b

# whether wind charges also get disguised/disabled while tagged, same as
# firework rockets - they can also be used to launch yourself away from a
# fight. default: off. change any time, survives reloads:
#   /data modify storage scdi:config disable_wind_charge set value 1b   (also disable wind charges)
#   /data modify storage scdi:config disable_wind_charge set value 0b   (firework rockets only, default)
execute unless data storage scdi:config disable_wind_charge run data modify storage scdi:config disable_wind_charge set value 0b

# whether the worn elytra also gets disguised/disabled while tagged - it can
# be used to fly away from a fight just as well as boosting with a rocket.
# unlike rockets/wind charges, the elytra's real enchantments/durability/name
# are captured and fully restored, not reset to a blank default. default:
# off. change any time, survives reloads:
#   /data modify storage scdi:config disable_elytra set value 1b   (also disable elytra)
#   /data modify storage scdi:config disable_elytra set value 0b   (off, default)
execute unless data storage scdi:config disable_elytra run data modify storage scdi:config disable_elytra set value 0b

# any number of extra items of your own choosing to also disable while
# tagged (any held item, not armor) - a real, unlimited-length list, managed
# through its own menu: /function scdi:menu/items. each entry is
# {item:"minecraft:<id>",scan_inventory:1b/0b}. real component data
# (enchantments etc) is captured and fully restored, same as elytra. can
# also be edited directly, no file editing needed:
#   /data modify storage scdi:config disguise_targets append value {item:"minecraft:ender_pearl",scan_inventory:1b}
#   /data remove storage scdi:config disguise_targets[0]
execute unless data storage scdi:config disguise_targets run data modify storage scdi:config disguise_targets set value []

# proximity-based tagging: instead of (well, in addition to) needing an
# actual hit, keeps items disabled continuously while another player stays
# within proximity_distance blocks. default: off. change any time, survives
# reloads:
#   /data modify storage scdi:config proximity_tagging set value 1b   (on)
#   /data modify storage scdi:config proximity_tagging set value 0b   (off, default)
#   /data modify storage scdi:config proximity_distance set value 6.0
#   /data modify storage scdi:config proximity_retag_distance set value 6.0   (see check_proximity.mcfunction - the range to STAY tagged, separate from the range to first trigger it)
execute unless data storage scdi:config proximity_tagging run data modify storage scdi:config proximity_tagging set value 0b
execute unless data storage scdi:config proximity_distance run data modify storage scdi:config proximity_distance set value 6.0
execute unless data storage scdi:config proximity_retag_distance run data modify storage scdi:config proximity_retag_distance set value 6.0

# proximity tagging normally treats both nearby players symmetrically -
# either both get proximity-tagged or neither does, ignoring tag_attacker/
# tag_victim entirely (there's no hit to tell attacker from victim). this
# infers a role instead, purely from recent movement (scdi_movement -
# apply_compute_proximity_movement.mcfunction): whichever of the two is
# moving MORE is treated as the attacker (gated by tag_attacker), whichever
# is moving the same amount or less (including both standing still) is
# treated as the victim (gated by tag_victim) - see
# check_proximity_role_movement.mcfunction. only affects the two
# plain-nearby-player checks (team_tag_proximity on, and off with neither
# player on a team) - the aggregate "nearby non-teammate" count used when a
# player has a team ignores this and keeps the original symmetric behavior,
# since that check can be satisfied by a dummy alone with no second real
# player to compare movement against. default: off (original symmetric
# behavior, tag_attacker/tag_victim don't apply to proximity at all). change
# any time, survives reloads:
#   /data modify storage scdi:config proximity_role_by_movement set value 1b   (infer attacker/victim from movement)
#   /data modify storage scdi:config proximity_role_by_movement set value 0b   (both tagged the same way, default)
execute unless data storage scdi:config proximity_role_by_movement run data modify storage scdi:config proximity_role_by_movement set value 0b

# radius (in blocks) cleared around a tagged player if they place a block
# matching the disguise item (see placed_block.json / on_placed_block.mcfunction).
# only matters if you've configured a placeable block as disguise_item - the
# default (a stick) is never placeable in the first place. change any
# time, survives reloads:
#   /data modify storage scdi:config placement_revert_radius set value 4
execute unless data storage scdi:config placement_revert_radius run data modify storage scdi:config placement_revert_radius set value 4

# temporary debugging aid: prints live match/condition results in chat every
# time a custom item slot gets checked. off by default - noisy. change any
# time, survives reloads:
#   /data modify storage scdi:config debug_custom_items set value 1b   (on)
#   /data modify storage scdi:config debug_custom_items set value 0b   (off, default)
execute unless data storage scdi:config debug_custom_items run data modify storage scdi:config debug_custom_items set value 0b

# another temporary debugging aid, separate from the one above: prints
# "[hit-dbg]" lines to EVERY player (see on_attacked_entity.mcfunction)
# every time any entity gets hit, listing the attacker and every entity
# within 6 blocks - used to track down whether dummy-hit detection was
# firing at all. off by default - noisy. change any time, survives reloads:
#   /data modify storage scdi:config debug_hit_messages set value 1b   (on)
#   /data modify storage scdi:config debug_hit_messages set value 0b   (off, default)
execute unless data storage scdi:config debug_hit_messages run data modify storage scdi:config debug_hit_messages set value 0b

# how often (in ticks, 20 = 1 second) each expensive periodic check runs -
# each one independently configurable. default for all four: 1 (every tick,
# same as before these settings existed). change any time, survives reloads:
#   /scoreboard players set $scan_interval scdi_const <ticks>              (full-inventory + custom item scanning)
#   /scoreboard players set $passive_restore_interval scdi_const <ticks>   (passive restore safety net)
#   /scoreboard players set $proximity_interval scdi_const <ticks>         (proximity tagging)
#   /scoreboard players set $nullify_interval scdi_const <ticks>           (mainhand/offhand/armor disguise check)
execute unless score $scan_interval scdi_const matches -2147483648..2147483647 run scoreboard players set $scan_interval scdi_const 1
execute unless score $passive_restore_interval scdi_const matches -2147483648..2147483647 run scoreboard players set $passive_restore_interval scdi_const 1
execute unless score $proximity_interval scdi_const matches -2147483648..2147483647 run scoreboard players set $proximity_interval scdi_const 1
# raising this above 1 means a tagged player's firework rocket/wind
# charge/worn elytra/custom item can stay REAL (not yet disguised) for up
# to this many ticks after being tagged or after switching to it - a
# genuine security/performance tradeoff, unlike the other three intervals
# above which only affect secondary safety nets, not the core lock itself.
# only raise this on a server that's actually struggling with per-tick
# cost from many simultaneously-tagged players; leave at 1 otherwise.
execute unless score $nullify_interval scdi_const matches -2147483648..2147483647 run scoreboard players set $nullify_interval scdi_const 1

# how often (in ticks) each tagged player/dummy's real-time combat-lock
# stopwatch gets QUERIED (combat_tick.mcfunction/dummy_combat_tick.mcfunction) -
# not the same as restarting it on a hit (retag_resets_timer), which always
# happens immediately regardless of this setting. "stopwatch" is a
# third-party mod command, not vanilla - its per-call cost isn't something
# this pack can inspect or control directly, but querying it 20x/second per
# tagged entity when the countdown it drives only visually changes once a
# second is more often than it needs to be. two tradeoffs from raising this
# above 1: the "(Tagged!)" flash in the first second after being tagged
# gets choppier (it reads the same elapsed-time snapshot for however many
# ticks pass between queries), and combat can end up to (interval-1) ticks
# later than the exact real-time deadline - both negligible at small values,
# noticeable if pushed high. default 1 (every tick, unchanged from before
# this setting existed). change any time, survives reloads:
#   /scoreboard players set $combat_tick_interval scdi_const <ticks>
execute unless score $combat_tick_interval scdi_const matches -2147483648..2147483647 run scoreboard players set $combat_tick_interval scdi_const 1

# how often (in ticks) the dummy passive-regen check runs - see
# dummy_regen_tick.mcfunction. default 20 (once a second) - cheap either
# way since there's normally 0-few dummies. change any time, survives
# reloads:
#   /scoreboard players set $dummy_regen_interval scdi_const <ticks>
execute unless score $dummy_regen_interval scdi_const matches -2147483648..2147483647 run scoreboard players set $dummy_regen_interval scdi_const 20

# how often (in ticks) each dummy's look-at-player rotation
# (apply_dummy_look_tick.mcfunction) and floating-display position tracking
# (apply_dummy_display_follow_tick.mcfunction) run - both cost scales with
# how many dummies exist at once (a nearest-player search PLUS a facing-angle
# recompute per dummy for the look check, a position re-teleport per display
# per dummy for the follow check), and neither needs true every-tick
# precision to look smooth - a head turning or a floating number trailing
# by up to 0.1s at default is imperceptible. default 2 (10/sec, still
# smooth) rather than 1 (20/sec) - cuts that per-dummy cost roughly in half
# with many dummies spawned at once, at essentially no visible cost. change
# any time, survives reloads:
#   /scoreboard players set $dummy_look_interval scdi_const <ticks>
#   /scoreboard players set $dummy_display_interval scdi_const <ticks>
execute unless score $dummy_look_interval scdi_const matches -2147483648..2147483647 run scoreboard players set $dummy_look_interval scdi_const 2
execute unless score $dummy_display_interval scdi_const matches -2147483648..2147483647 run scoreboard players set $dummy_display_interval scdi_const 2

# team-based exemption for proximity tagging (see check_proximity.mcfunction):
# players sharing the same non-zero scdi_team score never proximity-tag
# each other, so grouped players can stand together without keeping each
# other locked. 0 (default/unset) means "no team" - never exempts anyone.
# this is separate from vanilla teams; assign it directly, survives reloads:
#   /scoreboard players set <player> scdi_team <number>   (1, 2, 3... whichever side)
#   /scoreboard players set <player> scdi_team 0          (no team, default)
# for HIT-based tagging, teammates hitting each other is already solvable
# with vanilla's own mechanic instead - if they can't damage each other, our
# advancement never fires in the first place:
#   /team modify <team> friendlyFire false

# per-player admin exemption: a player with scdi_untaggable set to 1 or more
# can NEVER be tagged into combat at all, through any path (hit, proximity,
# tag_attacker, PvE, /function scdi:debug/tag - all of it) - checked first
# thing in on_hurt_by_player_tag_only.mcfunction/on_proximity_tag.mcfunction,
# before any tagging effect happens. also force-releases them immediately in
# tick.mcfunction if they're already mid-combat when this gets set. intended
# for staff/admins who need to spar or test without getting caught by their
# own pack. 0 (default/unset) means "taggable normally" - never exempts
# anyone. assign directly, survives reloads:
#   /scoreboard players set <player> scdi_untaggable 1   (immune, can't be tagged)
#   /scoreboard players reset <player> scdi_untaggable   (normal again, default)

# whether players in Creative mode are exempt from tagging entirely (as
# either victim or attacker) - off by default. Creative players already
# can't normally take PvP damage at all (vanilla blocks it), so this mostly
# matters for the ATTACKER side: without it, a creative-mode admin/builder
# swinging at a survival player while tag_attacker is on would still get
# tagged and have their own items disguised, which usually isn't the intent.
# also force-releases anyone already mid-combat the instant they switch into
# creative, same as scdi_untaggable above. change any time, survives reloads:
#   /data modify storage scdi:config ignore_creative set value 1b   (exempt creative players)
#   /data modify storage scdi:config ignore_creative set value 0b   (no exemption, default)
execute unless data storage scdi:config ignore_creative run data modify storage scdi:config ignore_creative set value 0b

# whether nulled items are actively re-checked/restored EVERY TICK for every
# player who isn't currently in combat (a continuous safety net, on top of
# whichever of scan_hotbar/scan_extended_inventory are on). on by default, but this runs for every
# online player every tick regardless of whether they were ever in combat,
# so it's the more expensive of the two settings - on a busy server with a
# lot of players you may notice it. turning it off does NOT stop items from
# being restored when combat ends - that always happens, exactly once, the
# instant the "Combat over" message shows. it only stops the extra ongoing
# checking for anyone not currently in combat. change any time, survives
# reloads:
#   /data modify storage scdi:config passive_restore set value 1b   (on, default)
#   /data modify storage scdi:config passive_restore set value 0b   (off - restore only exactly when combat ends)
execute unless data storage scdi:config passive_restore run data modify storage scdi:config passive_restore set value 1b

# whether the ATTACKER also gets combat-tagged (not just the victim) when they
# hit a player - stops "hit and run" (attack, then immediately elytra away
# completely untouched). default: on, both sides get tagged. change any time,
# survives reloads:
#   /data modify storage scdi:config tag_attacker set value 1b   (also tag attacker, default)
#   /data modify storage scdi:config tag_attacker set value 0b   (victim only)
execute unless data storage scdi:config tag_attacker run data modify storage scdi:config tag_attacker set value 1b

# whether the VICTIM gets combat-tagged when hit by a player - the original,
# always-on behavior. turn this off to flip tagging to attacker-only (combine
# with tag_attacker:1b for "only the attacker's items get disabled, not the
# victim's"). default: on, matches the original hardcoded behavior before this
# setting existed. change any time, survives reloads:
#   /data modify storage scdi:config tag_victim set value 1b   (victim gets tagged, default)
#   /data modify storage scdi:config tag_victim set value 0b   (victim untouched)
execute unless data storage scdi:config tag_victim run data modify storage scdi:config tag_victim set value 1b

# master switch for ALL hit-based tagging (victim, attacker, both PvE
# directions, dummies) in one flip - checked once in the single shared
# choke point every hit-tagging path funnels through
# (on_hurt_by_player_tag_only.mcfunction). turning this off does NOT touch
# proximity_tagging, which is a completely independent tagging path - this
# is for someone who wants proximity-only tagging without having to
# remember to also flip tag_attacker/tag_victim/pve_mode individually.
# default: on (hit-based tagging works normally). change any time, survives
# reloads:
#   /data modify storage scdi:config hit_tagging_enabled set value 1b   (on, default)
#   /data modify storage scdi:config hit_tagging_enabled set value 0b   (no hit ever tags anyone - proximity_tagging only, if that's also on)
execute unless data storage scdi:config hit_tagging_enabled run data modify storage scdi:config hit_tagging_enabled set value 1b

# whether a RANGED hit (arrow, trident, thrown potion, wind charge, any
# damage type tagged #minecraft:is_projectile in vanilla) counts toward
# hit-based tagging at all, same as a melee hit does. gated the same single
# choke point as hit_tagging_enabled above (on_hurt_by_player_tag_only.mcfunction),
# fed by a scratch flag ($hit_was_ranged, scdi_const) that the *_ranged.mcfunction
# reward-function variants set before delegating into the same shared logic
# a melee hit uses - see on_hurt_by_player.mcfunction/on_attacked_player.mcfunction/
# on_attacked_entity.mcfunction/on_hurt_by_anything.mcfunction for the melee/ranged
# advancement split this relies on (there's no way to inspect a damage
# source's type after the fact via commands, so detecting "was this ranged"
# has to happen at the advancement-criteria level, not inside the reward
# function). does NOT affect dummy damage/one-shot/health tracking
# (apply_check_dummy_hit.mcfunction) - a ranged hit still deals real
# damage and can still one-shot a dummy, it just won't by itself start/
# refresh anyone's combat lock if this is off. default: on (ranged counts
# same as melee, original behavior). change any time, survives reloads:
#   /data modify storage scdi:config ranged_attacks_tag set value 1b   (ranged hits tag same as melee, default)
#   /data modify storage scdi:config ranged_attacks_tag set value 0b   (only melee hits tag - ranged damage never starts/refreshes a combat lock)
execute unless data storage scdi:config ranged_attacks_tag run data modify storage scdi:config ranged_attacks_tag set value 1b

# whether hitting/being hit by a TEAMMATE still tags anyone, independent of
# the general tag_attacker/tag_victim toggles above. default: attacker still
# gets tagged (you're the one who screwed up swinging at a teammate), victim
# does NOT (they didn't do anything wrong, no reason to lock their items
# over someone else's mistake). guessed via proximity (the hit-detection
# advancements don't expose the other party's identity - see
# check_team_exemption_attacker.mcfunction/check_team_exemption_victim.mcfunction).
# change any time, survives reloads:
#   /data modify storage scdi:config team_tag_attacker set value 1b   (hitting a teammate still tags you, default)
#   /data modify storage scdi:config team_tag_attacker set value 0b   (hitting a teammate never tags you)
#   /data modify storage scdi:config team_tag_victim set value 1b     (getting hit by a teammate still tags you)
#   /data modify storage scdi:config team_tag_victim set value 0b     (getting hit by a teammate never tags you, default)
execute unless data storage scdi:config team_tag_attacker run data modify storage scdi:config team_tag_attacker set value 1b
execute unless data storage scdi:config team_tag_victim run data modify storage scdi:config team_tag_victim set value 0b

# whether PROXIMITY tagging (proximity_tagging above, off by default) also
# exempts teammates from tagging each other just by standing close, the same
# way team_tag_attacker/team_tag_victim above can exempt them from HIT-based
# tagging. off by default, which is actually the more restrictive state here
# despite matching the "off" pattern above - proximity tagging always
# exempted teammates unconditionally before this setting existed (see
# check_proximity_apply.mcfunction), so off = keep that original behavior,
# on = teammates proximity-tag each other exactly like any other nearby
# player. change any time, survives reloads:
#   /data modify storage scdi:config team_tag_proximity set value 1b   (teammates proximity-tag each other too)
#   /data modify storage scdi:config team_tag_proximity set value 0b   (teammates never proximity-tag each other, default)
execute unless data storage scdi:config team_tag_proximity run data modify storage scdi:config team_tag_proximity set value 0b

# whether test dummies count as a proximity-tagging source at all
# (check_proximity_apply.mcfunction) - on by default (a dummy standing
# near you keeps you tagged, same as a real player would). off excludes
# dummies from every proximity check entirely, so only real nearby players
# trigger it - useful for testing proximity tagging without a leftover
# dummy in the area silently keeping you locked. change any time, survives
# reloads:
#   /data modify storage scdi:config dummy_proximity_tagging set value 1b   (dummies count, default)
#   /data modify storage scdi:config dummy_proximity_tagging set value 0b   (dummies never proximity-tag)
execute unless data storage scdi:config dummy_proximity_tagging run data modify storage scdi:config dummy_proximity_tagging set value 1b

# whether one-shotting someone (killing them in the single hit that first
# tags them - see maybe_tag_attacker.mcfunction/check_one_shot_exemption_attacker.mcfunction)
# skips tagging the ATTACKER for that hit. off by default (attacker still
# gets tagged even on a clean kill, unchanged from original behavior) -
# tag_attacker's whole purpose is preventing hit-and-run escape from an
# ongoing fight, which doesn't apply once the fight's already over. guessed
# via proximity, same limitation as team_tag_attacker/team_tag_victim above.
# change any time, survives reloads:
#   /data modify storage scdi:config no_tag_on_one_shot_kill set value 1b   (skip tagging the attacker on a one-shot kill)
#   /data modify storage scdi:config no_tag_on_one_shot_kill set value 0b   (attacker always gets tagged, default)
execute unless data storage scdi:config no_tag_on_one_shot_kill run data modify storage scdi:config no_tag_on_one_shot_kill set value 0b

# same idea as no_tag_on_one_shot_kill above, but for the VICTIM: whether
# getting one-shot skips tagging the victim (default: off, unchanged -
# victim always gets tagged same as any other hit). no proximity guessing
# needed for this one (unlike the attacker side) - the victim can just
# check their own health directly. useful for repeated one-shot testing:
# with this on, a victim who gets instantly killed never stays tagged
# through their next respawn, so each subsequent instant kill still reads
# as a fresh "untagged going in" encounter and the one-shot announcement
# (announce_one_shot) fires every time, not just every other time. change
# any time, survives reloads:
#   /data modify storage scdi:config no_tag_victim_on_one_shot set value 1b   (skip tagging the victim on a one-shot kill, default)
#   /data modify storage scdi:config no_tag_victim_on_one_shot set value 0b   (victim always gets tagged)
execute unless data storage scdi:config no_tag_victim_on_one_shot run data modify storage scdi:config no_tag_victim_on_one_shot set value 1b

# whether a chat message announces a "one-shot" - a player's FIRST hit of a
# fresh encounter (not already tagged going in) also being the killing blow.
# hit-based only (see on_hurt_by_player.mcfunction/check_one_shot.mcfunction)
# - never fires from proximity_tagging, which isn't "getting hit" at all.
# can't name the attacker (the hit-detection advancement this runs from
# doesn't expose who dealt the damage - see the tag_attacker/tag_victim
# notes above for the same limitation). default: on. change any time,
# survives reloads:
#   /data modify storage scdi:config announce_one_shot set value 1b   (announce it, default)
#   /data modify storage scdi:config announce_one_shot set value 0b   (off)
execute unless data storage scdi:config announce_one_shot run data modify storage scdi:config announce_one_shot set value 1b

# bypasses the "first hit of a fresh encounter" requirement above entirely -
# EVERY kill announces as a one-shot (if announce_one_shot is on), even if
# the victim was already tagged/mid-fight, not just an instant kill from a
# clean start. default off (preserves the stricter, original meaning of
# "one-shot"). change any time, survives reloads:
#   /data modify storage scdi:config one_shot_ignore_tag set value 1b   (every kill counts)
#   /data modify storage scdi:config one_shot_ignore_tag set value 0b   (only a fresh-encounter kill counts, default)
execute unless data storage scdi:config one_shot_ignore_tag run data modify storage scdi:config one_shot_ignore_tag set value 0b

# optional tightening of what counts as a "one-shot" for the announcement
# above: off by default, meaning "one-shot" = just untagged going into this
# specific hit, same as always. when on, it ALSO requires @s to have been
# out of combat for at least one_shot_cooldown ticks - closes the "get them
# low, wait for the tag to expire, finish them off later" loophole, where a
# multi-encounter kill could otherwise still read as a genuine single-hit
# one-shot since the victim happens to be untagged at the exact moment of
# the finishing blow. change any time, survives reloads:
#   /data modify storage scdi:config one_shot_cooldown_enabled set value 1b   (tighter check)
#   /data modify storage scdi:config one_shot_cooldown_enabled set value 0b   (off, default - untagged going in is enough)
#   /data modify storage scdi:config one_shot_cooldown set value 200          (ticks since last combat end required, default 10s)
execute unless data storage scdi:config one_shot_cooldown_enabled run data modify storage scdi:config one_shot_cooldown_enabled set value 0b
execute unless data storage scdi:config one_shot_cooldown run data modify storage scdi:config one_shot_cooldown set value 200

# sound played the instant a player is tagged into combat. change any time,
# survives reloads:
#   /data modify storage scdi:config combat_sound set value "minecraft:<sound>"
#   /data modify storage scdi:config combat_pitch set value <0.5-2.0>
#   /data modify storage scdi:config combat_volume set value <0.0+>
execute unless data storage scdi:config combat_sound run data modify storage scdi:config combat_sound set value "minecraft:block.note_block.bit"
execute unless data storage scdi:config combat_pitch run data modify storage scdi:config combat_pitch set value 0.5f
execute unless data storage scdi:config combat_volume run data modify storage scdi:config combat_volume set value 1.0f

# sound played the instant combat ends. change any time, survives reloads:
#   /data modify storage scdi:config safe_sound set value "minecraft:<sound>"
#   /data modify storage scdi:config safe_pitch set value <0.5-2.0>
#   /data modify storage scdi:config safe_volume set value <0.0+>
execute unless data storage scdi:config safe_sound run data modify storage scdi:config safe_sound set value "minecraft:block.note_block.bit"
execute unless data storage scdi:config safe_pitch run data modify storage scdi:config safe_pitch set value 1.0f
execute unless data storage scdi:config safe_volume run data modify storage scdi:config safe_volume set value 1.0f

# per-item individual timer override (ms). 0 means "use the global $duration
# above" - each item (built-in or custom) can instead be given its own
# disable length, still starting/resetting from the same tag/retag moment as
# everything else (see get_effective_duration.mcfunction). while active, the
# item's disguised stack count is repurposed to show its own remaining
# seconds (clamped 1-99) instead of a fixed number - the real original count
# is captured separately and always used for the actual restore. change any
# time, survives reloads:
#   /data modify storage scdi:config firework_rocket_duration set value 10000
#   /data modify storage scdi:config wind_charge_duration set value 0        (0 = use global)
#   /data modify storage scdi:config elytra_duration set value 45000
#   custom items: /data modify storage scdi:config disguise_targets[N].duration set value 15000
execute unless data storage scdi:config firework_rocket_duration run data modify storage scdi:config firework_rocket_duration set value 0
execute unless data storage scdi:config wind_charge_duration run data modify storage scdi:config wind_charge_duration set value 0
execute unless data storage scdi:config elytra_duration run data modify storage scdi:config elytra_duration set value 0

# Misc: test dummy (minecraft:mannequin, a static player-shaped target for
# testing without needing a second real player) - whether the public
# ScdiDummy trigger is allowed to spawn one at all. off by default, since
# unlike everything else in this pack, letting any player spam-summon
# entities from chat is a real griefing/clutter vector if left on
# unattended - an admin has to opt in. change any time, survives reloads:
#   /data modify storage scdi:config allow_dummy_trigger set value 1b   (anyone can /trigger ScdiDummy)
#   /data modify storage scdi:config allow_dummy_trigger set value 0b   (disabled, default)
execute unless data storage scdi:config allow_dummy_trigger run data modify storage scdi:config allow_dummy_trigger set value 0b

# whether hitting a dummy tags the attacker at all (see
# on_attacked_entity.mcfunction) - separate from tag_attacker itself, so
# you can turn off JUST the dummy's ability to tag you (e.g. to hit dummies
# freely without triggering your own combat lock) while real player hits
# still tag normally. on by default. change any time, survives reloads:
#   /data modify storage scdi:config dummy_tagging set value 1b   (hitting a dummy tags the attacker, default)
#   /data modify storage scdi:config dummy_tagging set value 0b   (dummies never tag anyone)
execute unless data storage scdi:config dummy_tagging run data modify storage scdi:config dummy_tagging set value 1b

# the 4 keys below are all "what a NEWLY SPAWNED dummy starts with", read
# once by configure_new_dummy.mcfunction to initialize that dummy's own
# INDEPENDENT per-dummy score (scdi_dummy_combat_simulation/
# scdi_dummy_extinguish_in_combat/scdi_dummy_extinguish_on_cheat_death/
# scdi_dummy_cheat_death_invuln) - same relationship dummy_immobile
# already has with the per-dummy knockback_resistance attribute. changing
# one of these keys after a dummy already exists does NOT affect it
# retroactively; use the matching per-dummy toggle in the dummy trigger
# menu for that (same as Pin/Immobile/Invincible already work).

# whether a NEW dummy simulates its OWN combat lock when hit - independent
# of dummy_tagging above (which only controls whether the ATTACKER gets
# tagged). when on, getting hit starts/refreshes the dummy's own timer,
# during which its worn escape items (elytra, custom armor rules) get
# disguised exactly like a real player's would, then restored once the
# timer runs out - lets you test the full disguise/restore cycle
# (including the particle flash and optional recolor) on a dummy without
# needing a second real player. on by default. change any time, survives
# reloads:
#   /data modify storage scdi:config dummy_combat_simulation set value 1b   (new dummies simulate their own combat lock, default)
#   /data modify storage scdi:config dummy_combat_simulation set value 0b   (new dummies' gear is never disguised)
execute unless data storage scdi:config dummy_combat_simulation run data modify storage scdi:config dummy_combat_simulation set value 1b

# whether a NEW dummy self-extinguishes when on fire (see
# apply_dummy_start_extinguish.mcfunction for the full sequence - stops
# looking at the player, looks down, places a water block at its feet or
# head, waits briefly, then removes the water and the bucket) while it's
# in its own combat lock. independent of the cheat-death option below -
# either, both, or neither can be on. off by default. change any time,
# survives reloads:
#   /data modify storage scdi:config dummy_extinguish_in_combat set value 1b   (new dummies self-extinguish while tagged)
#   /data modify storage scdi:config dummy_extinguish_in_combat set value 0b   (never, default)
execute unless data storage scdi:config dummy_extinguish_in_combat run data modify storage scdi:config dummy_extinguish_in_combat set value 0b

# same self-extinguish sequence as above, triggered instead by an
# invincible dummy cheating death (apply_dummy_invincible_save.mcfunction) -
# a fresh "life" putting its own
# fire out along with everything else resetting. on by default. change
# any time, survives reloads:
#   /data modify storage scdi:config dummy_extinguish_on_cheat_death set value 1b   (new dummies self-extinguish on cheating death, default)
#   /data modify storage scdi:config dummy_extinguish_on_cheat_death set value 0b   (never)
execute unless data storage scdi:config dummy_extinguish_on_cheat_death run data modify storage scdi:config dummy_extinguish_on_cheat_death set value 1b

# whether a NEW invincible dummy cheating death also gets a brief window of
# damage immunity (minecraft:resistance at an amplifier high enough for
# 100% reduction, not literal Invulnerable - see
# apply_dummy_start_cheat_invuln.mcfunction for why), same idea as a real
# player's own post-respawn invulnerability. off by default - now that
# cheating death fires on every 20+ damage hit rather than rarely, a brief
# immunity window every time was overlapping constantly during sustained
# combat. change any time, survives reloads:
#   /data modify storage scdi:config dummy_cheat_death_invulnerability set value 1b   (new dummies get brief invulnerability after cheating death)
#   /data modify storage scdi:config dummy_cheat_death_invulnerability set value 0b   (can be hit again immediately, default)
execute unless data storage scdi:config dummy_cheat_death_invulnerability run data modify storage scdi:config dummy_cheat_death_invulnerability set value 0b

# whether a NEW dummy's cheat-death totem "pop" sound
# (apply_dummy_invincible_save.mcfunction) plays - per-dummy from here on
# (scdi_dummy_cheat_death_sound_totem, toggleable via the dummy trigger
# menu), this is just the default new ones spawn with. independent of the
# allay hum below - either/both/neither can be on. the particle burst
# isn't affected by either. on by default, matching the original always-on
# behavior. change any time, survives reloads:
#   /data modify storage scdi:config dummy_cheat_death_sound_totem set value 1b   (new dummies play the totem pop, default)
#   /data modify storage scdi:config dummy_cheat_death_sound_totem set value 0b   (new dummies skip the totem pop)
execute unless data storage scdi:config dummy_cheat_death_sound_totem run data modify storage scdi:config dummy_cheat_death_sound_totem set value 1b

# same idea for the allay hum, independent of the totem pop above. change
# any time, survives reloads:
#   /data modify storage scdi:config dummy_cheat_death_sound_allay set value 1b   (new dummies play the allay hum, default)
#   /data modify storage scdi:config dummy_cheat_death_sound_allay set value 0b   (new dummies skip the allay hum)
execute unless data storage scdi:config dummy_cheat_death_sound_allay run data modify storage scdi:config dummy_cheat_death_sound_allay set value 1b

# which particle effect plays on a dummy's cheat-death heal-back
# (apply_dummy_invincible_save.mcfunction) - any vanilla particle id, plain
# ones with no extra data work as-is (electric_spark, totem_of_undying,
# soul, soul_fire_flame, nautilus, etc); one needing extra data (like
# dust) would need its {..} written directly into this value too, e.g.
# "minecraft:dust{color:[0.2,0.5,1.0],scale:1.0}". this is just the
# default new dummies spawn with - per-dummy from here on
# (ScdiCheatDeathParticle entity NBT, toggleable via the dummy trigger
# menu, see configure_new_dummy.mcfunction for why this one lives on the
# entity instead of a score). default electric_spark. change any time,
# survives reloads:
#   /data modify storage scdi:config dummy_cheat_death_particle set value "minecraft:electric_spark"
execute unless data storage scdi:config dummy_cheat_death_particle run data modify storage scdi:config dummy_cheat_death_particle set value "minecraft:electric_spark"

# whether a NEW dummy spawns already invincible instead of mortal (see
# menu/dummy_menu_invincible_on.mcfunction for what "invincible" means -
# a big health pool + repeating "cheated death" segments instead of
# actually dying). off by default (spawns mortal, the traditional/expected
# starting point) - toggle an existing dummy afterward via the dummy
# trigger menu regardless of this setting. change any time, survives
# reloads:
#   /data modify storage scdi:config dummy_invincible_default set value 1b   (new dummies spawn invincible)
#   /data modify storage scdi:config dummy_invincible_default set value 0b   (new dummies spawn mortal, default)
execute unless data storage scdi:config dummy_invincible_default run data modify storage scdi:config dummy_invincible_default set value 0b

# whether a NEW dummy spawns already pinned in place (see
# menu/dummy_menu_pin_on.mcfunction/scdi_dummy_pinned's comment further up
# for what "pinned" means - stronger than knockback resistance, immune to
# pistons/currents/anything physical, not just combat hits) - captures its
# own spawn position as the pin point, same as toggling it on later would
# capture whatever position it's standing in at that moment. off by
# default (moves/gets pushed normally) - toggle an existing dummy
# afterward via the dummy trigger menu regardless of this setting. change
# any time, survives reloads:
#   /data modify storage scdi:config dummy_pinned_default set value 1b   (new dummies spawn pinned to their spawn point)
#   /data modify storage scdi:config dummy_pinned_default set value 0b   (new dummies can move/be moved, default)
execute unless data storage scdi:config dummy_pinned_default run data modify storage scdi:config dummy_pinned_default set value 0b

# whether every spawned dummy continuously turns to face the nearest player
# within dummy_look_range blocks (using teleport_command below, every tick -
# it has NoAI so this is the only thing that ever moves it). on by default.
# change any time, survives reloads:
#   /data modify storage scdi:config dummy_look_at_player set value 1b   (on, default)
#   /data modify storage scdi:config dummy_look_at_player set value 0b   (off - faces whatever direction it spawned facing)
execute unless data storage scdi:config dummy_look_at_player run data modify storage scdi:config dummy_look_at_player set value 1b

# how close (in blocks) a player needs to be for the above. only matters if
# dummy_look_at_player is on. change any time, survives reloads:
#   /data modify storage scdi:config dummy_look_range set value 5
execute unless data storage scdi:config dummy_look_range run data modify storage scdi:config dummy_look_range set value 5

# whether a dummy will pick up and wear armor dropped within 1.5 blocks of
# it, every tick - reads the item's own minecraft:equippable component to
# know it's armor and which slot, rather than hardcoding item ids (see
# dummy_pickup_tick.mcfunction). its own command-driven pickup, not vanilla
# mob AI - the dummy keeps NoAI regardless. off by default. change any time,
# survives reloads:
#   /data modify storage scdi:config dummy_pickup_items set value 1b   (on)
#   /data modify storage scdi:config dummy_pickup_items set value 0b   (off, default)
execute unless data storage scdi:config dummy_pickup_items run data modify storage scdi:config dummy_pickup_items set value 0b

# how far (in blocks) a player has to be from a dummy to see its chat
# announcements (one-shot, time-to-kill, cheated-death - see
# apply_check_dummy_hit2.mcfunction/apply_dummy_invincible_save.mcfunction) -
# these used to broadcast to the whole server (tellraw @a) regardless of
# distance, which got noisy fast with more than one dummy/fight going at
# once. does NOT affect the
# floating text_display above the dummy itself (that's always naturally
# distance-limited by render distance, not this setting). change any time,
# survives reloads:
#   /data modify storage scdi:config dummy_announce_range set value 24
execute unless data storage scdi:config dummy_announce_range run data modify storage scdi:config dummy_announce_range set value 24

# whether a floating "ONE SHOT" text_display briefly appears when a dummy is
# killed on its first-ever hit (see apply_check_dummy_hit.mcfunction).
# on by default - this is the whole point of the test dummy. change any
# time, survives reloads:
#   /data modify storage scdi:config dummy_announce_one_shot set value 1b   (on, default)
#   /data modify storage scdi:config dummy_announce_one_shot set value 0b   (off)
execute unless data storage scdi:config dummy_announce_one_shot run data modify storage scdi:config dummy_announce_one_shot set value 1b

# mirrors one_shot_ignore_tag above, for dummies - bypasses the "first-ever
# hit" requirement entirely, so every lethal hit announces as a one-shot,
# not just an instant kill from full health. default off. change any time,
# survives reloads:
#   /data modify storage scdi:config dummy_one_shot_ignore_tag set value 1b   (every lethal hit counts)
#   /data modify storage scdi:config dummy_one_shot_ignore_tag set value 0b   (only its first-ever hit counts, default)
execute unless data storage scdi:config dummy_one_shot_ignore_tag run data modify storage scdi:config dummy_one_shot_ignore_tag set value 0b

# whether killing a mortal dummy also announces how long the kill took, from
# the hit that took it off full health to the lethal hit
# (scdi_dummy_encounter_start_tick, set in apply_check_dummy_hit.mcfunction -
# the same "fresh encounter" marker DPS tracking already uses). on by
# default, same reasoning as dummy_announce_one_shot above. change any time,
# survives reloads:
#   /data modify storage scdi:config dummy_announce_time_to_kill set value 1b   (on, default)
#   /data modify storage scdi:config dummy_announce_time_to_kill set value 0b   (off)
execute unless data storage scdi:config dummy_announce_time_to_kill run data modify storage scdi:config dummy_announce_time_to_kill set value 1b

# the minimum time window (in ticks, 20/sec) the live DPS readout
# (apply_update_dummy_health_display.mcfunction) averages damage over,
# even right after a fresh encounter's first hit. without a floor here,
# that first hit gets divided by however few ticks have actually passed
# (as little as 1) and extrapolated into a wildly inflated instantaneous
# rate instead of a real sustained average - see
# apply_update_dummy_health_display.mcfunction for the full explanation.
# default 40 (2 seconds). raise it for a smoother/slower-to-react DPS
# number, lower it (minimum 1) for a twitchier one that reacts to single
# hits almost immediately, at the cost of it being less "real". change any
# time, survives reloads:
#   /data modify storage scdi:config dummy_dps_window set value 40
execute unless data storage scdi:config dummy_dps_window run data modify storage scdi:config dummy_dps_window set value 40

# whether an invincible dummy cheating death (any 20+ damage hit -
# apply_dummy_invincible_save.mcfunction heals it straight back to full)
# ALSO announces it in chat, on top of the floating "Cheated Death!"
# text_display it always gets regardless of this setting. off by default -
# the floating display alone is enough for most testing, and a long
# invincible fight can cheat death many times, so a chat message every time
# gets noisy fast. change any time, survives reloads:
#   /data modify storage scdi:config dummy_announce_cheated_death set value 1b   (also announce in chat)
#   /data modify storage scdi:config dummy_announce_cheated_death set value 0b   (floating display only, default)
execute unless data storage scdi:config dummy_announce_cheated_death run data modify storage scdi:config dummy_announce_cheated_death set value 0b

# whether a floating health readout (current/max) hovers above a dummy,
# updated every tick (see dummy_health_display_tick.mcfunction). on by
# default. change any time, survives reloads:
#   /data modify storage scdi:config dummy_show_health set value 1b   (on, default)
#   /data modify storage scdi:config dummy_show_health set value 0b   (off)
execute unless data storage scdi:config dummy_show_health run data modify storage scdi:config dummy_show_health set value 1b

# whether a dummy passively regenerates health once it's gone
# dummy_regen_delay ticks without taking any damage (see
# dummy_regen_tick.mcfunction / apply_dummy_regen_tick.mcfunction) - heals
# dummy_regen_amount health every $dummy_regen_interval ticks (default 20 =
# once a second) once eligible, clamped to its max health. on by default.
# change any time, survives reloads:
#   /data modify storage scdi:config dummy_regen set value 1b   (on, default)
#   /data modify storage scdi:config dummy_regen set value 0b   (off)
#   /data modify storage scdi:config dummy_regen_delay set value 100    (ticks since last damage before regen starts, default 5s)
#   /data modify storage scdi:config dummy_regen_amount set value 1     (health per regen tick, default half a heart)
execute unless data storage scdi:config dummy_regen run data modify storage scdi:config dummy_regen set value 1b
execute unless data storage scdi:config dummy_regen_delay run data modify storage scdi:config dummy_regen_delay set value 100
execute unless data storage scdi:config dummy_regen_amount run data modify storage scdi:config dummy_regen_amount set value 1

# whether a dummy is immune to knockback (stays exactly where it was
# spawned, never getting shoved around by hits) - NoAI alone doesn't stop
# this for a mannequin the way it would for a normal Mob, since a mannequin
# isn't one (no AI/pathfinding capability to begin with). implemented via
# the minecraft:knockback_resistance attribute, applied at spawn
# (configure_new_dummy.mcfunction) and live-updated on every existing
# dummy the instant this is toggled (menu/dummy_immobile_on.mcfunction/_off).
# on by default. change any time, survives reloads:
#   /data modify storage scdi:config dummy_immobile set value 1b   (on, default - stays put)
#   /data modify storage scdi:config dummy_immobile set value 0b   (off - takes real knockback)
execute unless data storage scdi:config dummy_immobile run data modify storage scdi:config dummy_immobile set value 1b

# whether new dummies spawn with NoGravity - on by default (stays exactly
# at spawn height, never falls). dummies no longer spawn with NoAI at all
# (removed - this game version's mannequin doesn't behave like a
# pathfinding Mob the way NoAI assumes, and it may have been interfering
# with its own death animation), so without this they'd otherwise fall like
# any other entity if spawned mid-air or the ground beneath them changes.
# change any time, survives reloads:
#   /data modify storage scdi:config dummy_no_gravity set value 1b   (on - never falls)
#   /data modify storage scdi:config dummy_no_gravity set value 0b   (off, default - falls normally)
execute unless data storage scdi:config dummy_no_gravity run data modify storage scdi:config dummy_no_gravity set value 0b

# a dummy's max health (set on spawn via configure_new_dummy.mcfunction) -
# deliberately much larger than a real player's 20. this is PURELY a safety
# buffer against item loss now, not the thing that decides when a mortal
# dummy actually dies - see dummy_one_shot_damage below and
# apply_check_dummy_hit2.mcfunction/scdi_dummy_sim_hp for the real death
# gate. default 10000. only takes effect for NEWLY spawned dummies, not
# existing ones. change any time, survives reloads:
#   /data modify storage scdi:config dummy_max_health set value 10000
execute unless data storage scdi:config dummy_max_health run data modify storage scdi:config dummy_max_health set value 10000

# a mortal dummy's real death gate: a SIMULATED health pool (scdi_dummy_sim_hp,
# see configure_new_dummy.mcfunction/apply_check_dummy_hit.mcfunction/
# apply_dummy_regen_heal.mcfunction), capped at this value and tracked
# completely separately from the large safety-buffer pool above - drains by
# the exact same amount as every hit that pool takes, regenerates on the
# same passive-regen schedule, and dying happens the instant it reaches 0.
# this is what makes a mortal dummy actually behave like a player
# replacement under SUSTAINED combat, not just a single one-shot-capable
# hit: two hits of 12 each wouldn't individually reach this value, but
# their SUM does, exactly like it would against a real player, whereas
# checking the big buffer pool alone would barely notice either hit.
# default 20 - a normal player's own max health. change any time, survives
# reloads:
#   /data modify storage scdi:config dummy_one_shot_damage set value 20
execute unless data storage scdi:config dummy_one_shot_damage run data modify storage scdi:config dummy_one_shot_damage set value 20

# whether a brief RPG-style floating "-N" damage number pops out of a dummy
# every time it takes damage (see spawn_dummy_damage_display.mcfunction).
# on by default. change any time, survives reloads:
#   /data modify storage scdi:config dummy_damage_numbers set value 1b   (on, default)
#   /data modify storage scdi:config dummy_damage_numbers set value 0b   (off)
execute unless data storage scdi:config dummy_damage_numbers run data modify storage scdi:config dummy_damage_numbers set value 1b

# how many ticks (20 = 1 second) a sent team request stays pending before it
# automatically expires - both the target and the original requester (if
# still online) get told it wasn't accepted in time (see
# team_request_expiry_tick.mcfunction/apply_expire_team_request.mcfunction).
# default 600 (30 seconds). change any time, survives reloads:
#   /data modify storage scdi:config team_request_timeout set value 600
execute unless data storage scdi:config team_request_timeout run data modify storage scdi:config team_request_timeout set value 600

# whether everyone's scdi_team number shows next to their name in the tab
# list (vanilla's "list" scoreboard display slot) - a single GLOBAL slot
# shared by the whole world, same caveat as show_timer_above_head/
# below_name: vanilla has no command to query what's currently on a
# display slot, only to set/clear one, so tablist_restore_objective below
# is the same manual workaround (put another objective's name there
# BEFORE turning this on if something else was already using the tab list,
# and turning this back off restores it instead of just clearing). off by
# default. change any time, survives reloads:
#   /data modify storage scdi:config show_team_on_tab set value 1b   (on)
#   /data modify storage scdi:config show_team_on_tab set value 0b   (off, default)
execute unless data storage scdi:config show_team_on_tab run data modify storage scdi:config show_team_on_tab set value 0b
execute if data storage scdi:config {show_team_on_tab:1b} run scoreboard objectives setdisplay list scdi_team

# see show_team_on_tab just above - the objective name to hand the tab
# list slot BACK to once this pack releases it, instead of just clearing
# it. empty string (default) means "there wasn't a previous one, just
# clear it" - see apply_release_tablist.mcfunction.
#   /data modify storage scdi:config tablist_restore_objective set value "my_other_objective"
#   /data modify storage scdi:config tablist_restore_objective set value ""   (default - just clear on release)
execute unless data storage scdi:config tablist_restore_objective run data modify storage scdi:config tablist_restore_objective set value ""

# which command repositions/re-orients entities this pack actively moves
# every tick (currently: the floating timer display in
# apply_update_timer_display.mcfunction, and the dummy look-at-player
# rotation above) - confirmed by direct testing that "teleport" interpolates
# with the technique used here and "tp" does not, on this game version.
# default: "teleport". change any time, survives reloads:
#   /data modify storage scdi:config teleport_command set value "teleport"   (interpolated, default)
#   /data modify storage scdi:config teleport_command set value "tp"         (no interpolation)
execute unless data storage scdi:config teleport_command run data modify storage scdi:config teleport_command set value "teleport"

# how many ticks the floating timer display's position updates interpolate
# over (see apply_configure_timer_display.mcfunction/
# apply_update_timer_display.mcfunction) - only matters when teleport_command
# is "teleport", since that's the one that actually interpolates. shouldn't
# normally need changing; 3 already reads as smooth tracking without lagging
# noticeably behind the player. default: 3. change any time, survives
# reloads (only applies to displays spawned AFTER the change, since it's set
# once at spawn, not re-applied every tick):
#   /data modify storage scdi:config timer_display_teleport_duration set value 3
execute unless data storage scdi:config timer_display_teleport_duration run data modify storage scdi:config timer_display_teleport_duration set value 3

tellraw @a ["",{"text":"(✔) ","bold":true,"color":"green"},{"text":"Combat Disabled Items","italic":true,"color":"red"},{"text":" by ","color":"gold"},{"text":"sacdj ","color":"dark_purple"},{"player":"sacdj","click_event":{"action":"open_url","url":"https://modrinth.com/user/sacdj"},"hover_event":{"action":"show_text","value":"Check out all my other stuff!"}}," ",{"text":"Loaded!","color":"green"}]
tellraw @a ["",{"text":"[SCDI] ","color":"red"},{"text":"Click here","color":"aqua","underlined":true,"click_event":{"action":"run_command","command":"/trigger ScdiHelp"},"hover_event":{"action":"show_text","value":"See how this pack works and what's currently disabled while tagged."}},{"text":" for help/info.","color":"gray"}]
tellraw @a[level=2..] ["",{"text":"[SCDI] ","color":"red"},{"text":"Click here","color":"aqua","underlined":true,"click_event":{"action":"run_command","command":"/trigger ScdiMenu"},"hover_event":{"action":"show_text","value":"Open the settings menu"}},{"text":" to view/change settings.","color":"gray"}]
