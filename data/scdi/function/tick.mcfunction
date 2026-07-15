# death detection: deathCount only ever goes up, so comparing it against the
# last value we saw catches a death regardless of respawn timing. initialize
# any new/never-died player's baseline to 0 first so this doesn't false-fire
# the very first tick they're seen.
scoreboard players add @a scdi_last_deaths 0
execute as @a unless score @s scdi_deaths = @s scdi_last_deaths run function scdi:on_death

# defaults every online player's scdi_team to 0 (no team) the first time
# they're seen, without touching one an admin already assigned - needed so
# "scoreboard players get @s scdi_team" in check_proximity.mcfunction never
# fails for a player who's never been assigned to a side
scoreboard players add @a scdi_team 0

# global tick counter, used to throttle each expensive periodic check below
# independently, on its own interval (see load.mcfunction: scan_interval,
# passive_restore_interval, proximity_interval). the held-item disguise
# check itself always runs every tick regardless - only the heavier
# inventory-scan/custom-item/passive-restore/proximity checks respect these.
scoreboard players add $ticks scdi_const 1
scoreboard players operation $scan_mod scdi_const = $ticks scdi_const
scoreboard players operation $scan_mod scdi_const %= $scan_interval scdi_const
scoreboard players operation $passive_mod scdi_const = $ticks scdi_const
scoreboard players operation $passive_mod scdi_const %= $passive_restore_interval scdi_const
scoreboard players operation $proximity_mod scdi_const = $ticks scdi_const
scoreboard players operation $proximity_mod scdi_const %= $proximity_interval scdi_const
scoreboard players operation $dummy_regen_mod scdi_const = $ticks scdi_const
scoreboard players operation $dummy_regen_mod scdi_const %= $dummy_regen_interval scdi_const

# immediately release anyone who becomes exempt while already mid-combat -
# an admin getting flagged scdi_untaggable, or a player switching into
# Creative while ignore_creative is on, shouldn't have to wait out a timer
# that was never supposed to apply to them in the first place
execute as @a[scores={scdi_tag=1,scdi_untaggable=1..}] run function scdi:combat_end
execute if data storage scdi:config {ignore_creative:1b} as @a[scores={scdi_tag=1},gamemode=creative] run function scdi:combat_end

# only players currently tagged as "in combat" need the timer/nullify logic
execute as @a[scores={scdi_tag=1}] run function scdi:combat_tick

# dummy combat-tag simulation (default on, dummy_combat_simulation - see
# apply_check_dummy_hit.mcfunction) - same idea as the player loop just
# above, for whichever dummies are currently in their own combat-lock.
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,scores={scdi_dummy_tag=1}] at @s run function scdi:dummy_combat_tick

# finishes a dummy's self-extinguish sequence once its timer runs out (see
# apply_dummy_start_extinguish.mcfunction/check_dummy_extinguish.mcfunction) -
# checked independently of the combat-tag loop above, not scoped to
# scdi_dummy_tag=1, since the sequence's short window can outlast the
# combat lock itself ending in the same few ticks.
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,scores={scdi_dummy_extinguishing=1}] at @s if score $ticks scdi_const >= @s scdi_dummy_extinguish_until run function scdi:apply_dummy_finish_extinguish

# fires the armor/inventory warning SOUND once its short queued delay has
# elapsed (see scdi_armor_warning_sound_at's comment in load.mcfunction/
# check_armor_warning.mcfunction/check_inventory_warning.mcfunction) - kept
# off the combat-tag loop above since it needs to fire even if combat ends
# in the meantime.
execute as @a[scores={scdi_armor_warning_sound_at=0..}] at @s if score @s scdi_armor_warning_sound_at <= $ticks scdi_const run function scdi:apply_fire_armor_warning_sound
execute as @a[scores={scdi_inventory_warning_sound_at=0..}] at @s if score @s scdi_inventory_warning_sound_at <= $ticks scdi_const run function scdi:apply_fire_inventory_warning_sound


# proximity-based tagging (optional, off by default - see load.mcfunction):
# keeps items disabled continuously while another player is nearby, on top
# of (not instead of) normal hit-based tagging
execute if score $proximity_mod scdi_const matches 0 if data storage scdi:config {proximity_tagging:1b} as @a at @s run function scdi:check_proximity

# feeds proximity_role_by_movement (see load.mcfunction/
# check_proximity_role_movement.mcfunction) - every tick, not throttled by
# proximity_interval, since motion needs sampling every tick to mean
# anything.
execute if data storage scdi:config {proximity_tagging:1b} if data storage scdi:config {proximity_role_by_movement:1b} as @a run function scdi:apply_compute_proximity_movement

# passive safety net (optional, on by default - see load.mcfunction): scans
# EVERY online player who isn't currently in combat, every
# passive_restore_interval ticks, for a stray nulled item and restores it
# immediately. covers a disguised item that got moved out of hand during
# combat and only re-equipped/pulled from storage after combat already
# ended. this is separate from, and in addition to, the guaranteed one-time
# restore that always happens in combat_end.mcfunction the instant combat
# actually ends, regardless of this setting.
execute if score $passive_mod scdi_const matches 0 if data storage scdi:config {passive_restore:1b} as @a unless score @s scdi_tag matches 1 run function scdi:restore_check

# orphaned timer-display cleanup: this entity normally gets killed the
# instant combat_end.mcfunction runs, but a player logging off mid-combat
# leaves it behind with nothing left to track it, which would otherwise
# leave a stray floating display behind forever (it has no natural despawn
# timer). distance=..4, not ..1 - the display sits 2.6 blocks above its
# owning player's actual position (see apply_update_timer_display.mcfunction),
# not colocated with them, so the check has to allow for that same gap
# rather than assuming they're at (roughly) the same spot. runs regardless
# of the current show_timer_text_display setting (not gated on it) so a
# display orphaned before the setting got turned off still gets swept up.
# cheap in practice - there's normally 0-few of these entities in existence.
execute if score $passive_mod scdi_const matches 0 as @e[type=minecraft:text_display,tag=scdi_timer_display] at @s unless entity @a[scores={scdi_tag=1},distance=..4] run kill @s

# public /trigger access to /help and /menu - plain /function requires
# permission level 2 (op) to even invoke, full stop, regardless of what the
# function itself checks internally. "trigger" scoreboard objectives are
# vanilla's mechanism for letting ANY player (level 0+) fire a datapack
# action from chat instead. each use disables itself until re-enabled, so
# re-enabling every tick here just means it's always ready again by the next
# tick. menu.mcfunction still does its own op check once reached - this only
# fixes the fact that non-ops couldn't even reach that check before.
scoreboard players enable @a ScdiHelp
scoreboard players enable @a ScdiMenu
scoreboard players enable @a ScdiDummy
scoreboard players enable @a ScdiDummyMenu
scoreboard players enable @a ScdiDummyMenu2
scoreboard players enable @a ScdiTeamRequest
scoreboard players enable @a ScdiTeamConfirm
scoreboard players enable @a ScdiTeamReset
scoreboard players enable @a ScdiDummyAction
scoreboard players enable @a ScdiPlayerMenu
scoreboard players enable @a ScdiPlayerMenuAction
execute as @a[scores={ScdiHelp=1..}] at @s run function scdi:help
execute as @a[scores={ScdiHelp=1..}] run scoreboard players set @s ScdiHelp 0
execute as @a[scores={ScdiMenu=1..}] at @s run function scdi:menu
execute as @a[scores={ScdiMenu=1..}] run scoreboard players set @s ScdiMenu 0
execute as @a[scores={ScdiDummy=1..}] at @s run function scdi:dummy_trigger
execute as @a[scores={ScdiDummy=1..}] run scoreboard players set @s ScdiDummy 0
execute as @a[scores={ScdiDummyMenu=1..}] at @s run function scdi:dummy_menu_trigger
execute as @a[scores={ScdiDummyMenu=1..}] run scoreboard players set @s ScdiDummyMenu 0
execute as @a[scores={ScdiDummyMenu2=1..}] at @s run function scdi:dummy_menu2_trigger
execute as @a[scores={ScdiDummyMenu2=1..}] run scoreboard players set @s ScdiDummyMenu2 0
execute as @a[scores={ScdiTeamRequest=1..}] at @s run function scdi:team_request_trigger
execute as @a[scores={ScdiTeamRequest=1..}] run scoreboard players set @s ScdiTeamRequest 0
execute as @a[scores={ScdiTeamConfirm=1..}] at @s run function scdi:team_confirm_trigger
execute as @a[scores={ScdiTeamConfirm=1..}] run scoreboard players set @s ScdiTeamConfirm 0
execute as @a[scores={ScdiTeamReset=1..}] at @s run function scdi:team_reset_trigger
execute as @a[scores={ScdiTeamReset=1..}] run scoreboard players set @s ScdiTeamReset 0
# see load.mcfunction's ScdiDummyAction comment - dispatches whichever
# dummy-menu button a player just clicked (set as a specific numeric
# value, not just enabled to 1) via the server's own full permissions,
# since the player themselves can't run /function directly.
execute as @a[scores={ScdiDummyAction=1..}] at @s run function scdi:dummy_menu_action_dispatch
execute as @a[scores={ScdiDummyAction=1..}] run scoreboard players set @s ScdiDummyAction 0
execute as @a[scores={ScdiPlayerMenu=1..}] at @s run function scdi:player_menu_trigger
execute as @a[scores={ScdiPlayerMenu=1..}] run scoreboard players set @s ScdiPlayerMenu 0
execute as @a[scores={ScdiPlayerMenuAction=1..}] at @s run function scdi:player_menu_action_dispatch
execute as @a[scores={ScdiPlayerMenuAction=1..}] run scoreboard players set @s ScdiPlayerMenuAction 0

# expiry sweep for pending team requests (see apply_team_request.mcfunction/
# load.mcfunction: team_request_timeout) - every tick, cheap since
# scdi_team_requested_by_id is normally unset for almost everyone.
function scdi:team_request_expiry_tick

# Misc: dummy look-at-player (off by default, see load.mcfunction) - runs
# every tick, not on an interval, since there's normally only a handful of
# dummies at most and choppy head-tracking would look worse than the
# negligible cost of checking every tick.
execute if data storage scdi:config {dummy_look_at_player:1b} run function scdi:dummy_look_tick

# Misc: dummy item pickup/equip (off by default, see load.mcfunction) -
# every tick, same reasoning as the look-at check above.
execute if data storage scdi:config {dummy_pickup_items:1b} run function scdi:dummy_pickup_tick

# expiry sweep for one-off "ONE SHOT" displays (see
# spawn_dummy_one_shot_display.mcfunction) - runs regardless of
# dummy_announce_one_shot, same reasoning as the timer-display orphan sweep:
# a display already spawned before the setting got turned off should still
# get cleaned up. cheap - there's normally 0-few of these in existence.
execute as @e[type=minecraft:text_display,tag=scdi_dummy_one_shot_display] run function scdi:apply_expire_one_shot_display
execute as @e[type=minecraft:text_display,tag=scdi_dummy_tag_display] run function scdi:apply_expire_dummy_tag_display
execute as @e[type=minecraft:text_display,tag=scdi_dummy_damage_display] run function scdi:apply_expire_dummy_damage_display
execute as @e[type=minecraft:text_display,tag=scdi_dummy_cheated_death_display] run function scdi:apply_expire_dummy_cheated_death_display

# Misc: dummy health display (on by default, see load.mcfunction) - every
# tick, so it reflects damage/heal-back immediately.
execute if data storage scdi:config {dummy_show_health:1b} run function scdi:dummy_health_display_tick

# orphaned dummy-health-display cleanup - same reasoning as the timer
# display's orphan sweep: a dummy can be removed ([Remove]/[Remove all]/
# uninstall) without going through combat_end-style cleanup, which would
# otherwise leave its health display floating forever.
execute as @e[type=minecraft:text_display,tag=scdi_dummy_health_display] at @s unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..3] run kill @s

# Misc: dummy passive health regen (on by default, see load.mcfunction) -
# throttled to $dummy_regen_interval ticks, unlike the health display above
# which needs to reflect damage every tick.
execute if score $dummy_regen_mod scdi_const matches 0 run function scdi:dummy_regen_tick

# Misc: dummy display position tracking - every tick, unconditionally (not
# gated on any one display setting - a dummy might have several different
# displays active/expiring at once). needed now that a dummy can actually
# move (knockback, unless dummy_immobile is on) instead of assuming it's
# always stationary.
function scdi:dummy_display_follow_tick

# Misc: pinned dummies (per-dummy toggle, see menu/dummy_menu_pin_on.mcfunction/
# _off.mcfunction - no global default) get teleported back to their exact
# captured position every tick, unconditionally - immune to pistons,
# water/lava currents, or anything else that would displace them, unlike
# dummy_immobile above which only dampens combat knockback.
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,scores={scdi_dummy_pinned=1..}] at @s run function scdi:apply_dummy_pin_tick
