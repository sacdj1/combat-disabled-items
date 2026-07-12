# does the actual cleanup work for uninstall.mcfunction (which does the op
# check first). order matters: items must be restored and stopwatches
# removed BEFORE the scoreboard objectives they depend on ($next_id etc, and
# per-player scdi_id/scdi_tag) are wiped out from under them.

# step 1: restore every currently-disguised item for every ONLINE player,
# unconditionally - bypasses the scan_inventory setting (forced on here
# regardless) since this is the last chance before the pack's own tick-based
# restore logic stops running entirely. can only reach players who are
# currently online - if someone offline has a disguised item sitting in
# their inventory, they'll need to log in (with the pack still installed)
# and either wait out combat or run this again before you actually delete
# the datapack files.
execute as @a at @s run function scdi:restore_check
execute as @a at @s run function scdi:restore_inventory

# step 2: revoke any pack advancement a player might currently be holding
# mid-tick (these are normally revoked the instant their reward fires, so
# this is defensive/rare, not the common case)
advancement revoke @a only scdi:hurt_by_player
advancement revoke @a only scdi:hurt_by_anything
advancement revoke @a only scdi:attacked_player
advancement revoke @a only scdi:attacked_entity
advancement revoke @a only scdi:placed_block

# step 3: floating timer-display entities, one-off "ONE SHOT" displays, the
# below_name display slot, and any spawned test dummies (armor they've
# picked up goes with them, since it's just their own equipment NBT). the
# below_name release is gated on show_timer_above_head actually being on -
# it's a single slot shared by the whole world, so clearing it unconditionally
# would rip out some OTHER datapack/plugin's display if this pack never
# claimed the slot in the first place.
kill @e[type=minecraft:text_display,tag=scdi_timer_display]
kill @e[type=minecraft:text_display,tag=scdi_dummy_one_shot_display]
kill @e[type=minecraft:text_display,tag=scdi_dummy_tag_display]
kill @e[type=minecraft:text_display,tag=scdi_dummy_damage_display]
kill @e[type=minecraft:text_display,tag=scdi_dummy_cheated_death_display]
kill @e[type=minecraft:text_display,tag=scdi_dummy_health_display]
kill @e[type=minecraft:mannequin,tag=scdi_dummy]
execute if data storage scdi:config {show_timer_above_head:1b} run scoreboard objectives setdisplay below_name

# step 4: best-effort per-player stopwatch removal (see
# apply_uninstall_stopwatch_at_id.mcfunction for why this is best-effort) -
# must happen before scdi_const (which holds $next_id) is removed below
scoreboard players set $uninstall_idx scdi_const 1
function scdi:apply_uninstall_stopwatches

# step 5: wipe stored config - "data remove storage scdi:config" alone isn't
# valid (the path argument is required, can't target the whole root at
# once), so this removes every known top-level key individually instead.
# scdi:tmp/tmp2/tmp3 are pure scratch space overwritten before every read
# with no persistent meaning, so there's nothing worth clearing there.
data remove storage scdi:config allow_dummy_trigger
data remove storage scdi:config dummy_tagging
data remove storage scdi:config announce_one_shot
data remove storage scdi:config one_shot_cooldown_enabled
data remove storage scdi:config one_shot_cooldown
data remove storage scdi:config combat_pitch
data remove storage scdi:config combat_sound
data remove storage scdi:config combat_volume
data remove storage scdi:config debug_custom_items
data remove storage scdi:config debug_hit_messages
data remove storage scdi:config disable_elytra
data remove storage scdi:config disable_firework_rocket
data remove storage scdi:config disable_wind_charge
data remove storage scdi:config disguise_glint
data remove storage scdi:config disguise_item
data remove storage scdi:config disguise_model
data remove storage scdi:config disguise_name
data remove storage scdi:config disguise_name_bold
data remove storage scdi:config disguise_name_color
data remove storage scdi:config disguise_name_italic
data remove storage scdi:config disguise_targets
data remove storage scdi:config dummy_announce_one_shot
data remove storage scdi:config dummy_one_shot_ignore_tag
data remove storage scdi:config dummy_announce_cheated_death
data remove storage scdi:config dummy_look_at_player
data remove storage scdi:config dummy_look_range
data remove storage scdi:config dummy_pickup_items
data remove storage scdi:config dummy_damage_numbers
data remove storage scdi:config dummy_death_threshold
data remove storage scdi:config dummy_one_shot_damage
data remove storage scdi:config dummy_max_health
data remove storage scdi:config dummy_immobile
data remove storage scdi:config dummy_no_gravity
data remove storage scdi:config team_request_timeout
data remove storage scdi:config dummy_regen
data remove storage scdi:config dummy_regen_amount
data remove storage scdi:config dummy_regen_delay
data remove storage scdi:config dummy_show_health
data remove storage scdi:config elytra_duration
data remove storage scdi:config firework_rocket_duration
data remove storage scdi:config ignore_creative
data remove storage scdi:config passive_restore
data remove storage scdi:config placement_revert_radius
data remove storage scdi:config proximity_distance
data remove storage scdi:config proximity_retag_distance
data remove storage scdi:config proximity_tagging
data remove storage scdi:config pve_mode
data remove storage scdi:config reset_on_death
data remove storage scdi:config retag_resets_timer
data remove storage scdi:config safe_pitch
data remove storage scdi:config safe_sound
data remove storage scdi:config safe_volume
data remove storage scdi:config scan_inventory
data remove storage scdi:config show_hotbar_text
data remove storage scdi:config show_disabled_text
data remove storage scdi:config show_tag_title
data remove storage scdi:config show_timer_above_head
data remove storage scdi:config show_timer_text_display
data remove storage scdi:config tag_attacker
data remove storage scdi:config tag_victim
data remove storage scdi:config team_tag_attacker
data remove storage scdi:config team_tag_victim
data remove storage scdi:config no_tag_on_one_shot_kill
data remove storage scdi:config no_tag_victim_on_one_shot
data remove storage scdi:config one_shot_ignore_tag
data remove storage scdi:config teleport_command
data remove storage scdi:config timer_display_teleport_duration
data remove storage scdi:config wind_charge_duration

# step 6: remove every scoreboard objective this pack created - removing an
# objective also wipes every score tied to it in one shot (both real
# players' scdi_tag/scdi_id/etc AND the fake "$"-prefixed constant players
# living on scdi_const), so there's no separate per-player reset step needed
scoreboard objectives remove scdi_tag
scoreboard objectives remove scdi_id
scoreboard objectives remove scdi_elapsed
scoreboard objectives remove scdi_sec
scoreboard objectives remove scdi_pct
scoreboard objectives remove scdi_flash
scoreboard objectives remove scdi_health
scoreboard objectives remove scdi_const
scoreboard objectives remove scdi_deaths
scoreboard objectives remove scdi_last_deaths
scoreboard objectives remove scdi_team
scoreboard objectives remove scdi_last_combat_end_tick
scoreboard objectives remove scdi_team_requested_by_id
scoreboard objectives remove scdi_team_request_tick
scoreboard objectives remove scdi_untaggable
scoreboard objectives remove scdi_owner_id
scoreboard objectives remove scdi_dummy_hit
scoreboard objectives remove scdi_dummy_last_hit
scoreboard objectives remove scdi_dummy_id
scoreboard objectives remove scdi_dummy_dmg
scoreboard objectives remove scdi_dummy_health_fine
scoreboard objectives remove scdi_dummy_total_dmg
scoreboard objectives remove scdi_dummy_encounter_start_tick
scoreboard objectives remove scdi_dummy_invincible
scoreboard objectives remove scdi_dummy_invincible_floor
scoreboard objectives remove scdi_dummy_pickup_cooldown_until
scoreboard objectives remove scdi_display_spawn_tick
scoreboard objectives remove scdi_item_dur
scoreboard objectives remove scdi_item_sec
scoreboard objectives remove ScdiHelp
scoreboard objectives remove ScdiMenu
scoreboard objectives remove ScdiDummy
scoreboard objectives remove ScdiDummyMenu
scoreboard objectives remove ScdiTeamRequest
scoreboard objectives remove ScdiTeamConfirm
scoreboard objectives remove ScdiTeamReset

tellraw @a ["",{"text":"[SCDI] ","color":"red"},{"text":"Combat Disabled Items has been uninstalled - all scoreboards, storage, and world entities it created have been removed. Delete the datapack from your world's datapacks folder now (this function can't remove itself).","color":"gray"}]
