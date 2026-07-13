# unconditionally forces every /menu-configurable setting back to its
# out-of-the-box default (mirrors every default in load.mcfunction exactly -
# keep the two in sync if a new setting is ever added). called only from
# reset_config.mcfunction, which does the op check first.
#
# release the below_name display slot BEFORE resetting show_timer_above_head
# below, gated on its CURRENT (pre-reset) value - below_name is a single
# slot shared by the whole world, so only release it if this pack actually
# claimed it; otherwise some other datapack/plugin's display would get
# clobbered by a reset that had nothing to do with them.
execute if data storage scdi:config {show_timer_above_head:1b} run scoreboard objectives setdisplay below_name

scoreboard players set $duration scdi_const 10000
scoreboard players set $scan_interval scdi_const 1
scoreboard players set $passive_restore_interval scdi_const 1
scoreboard players set $proximity_interval scdi_const 1
scoreboard players set $dummy_regen_interval scdi_const 20

data modify storage scdi:config disguise_item set value "minecraft:stick"
data modify storage scdi:config disguise_model set value "minecraft:barrier"
data modify storage scdi:config disguise_armor_model set value "minecraft:leather"
data modify storage scdi:config disguise_armor_flash set value 1b
data modify storage scdi:config disguise_armor_flash_interval set value 4
data modify storage scdi:config disguise_name set value "Items Disabled!"
data modify storage scdi:config disguise_name_color set value "red"
data modify storage scdi:config disguise_name_bold set value 1b
data modify storage scdi:config disguise_name_italic set value 0b
data modify storage scdi:config disguise_glint set value 1b
data modify storage scdi:config ignore_creative set value 0b
data modify storage scdi:config pve_mode set value 0b
data modify storage scdi:config reset_on_death set value 0b
data modify storage scdi:config retag_resets_timer set value 1b
data modify storage scdi:config show_hotbar_text set value 1b
data modify storage scdi:config show_disabled_text set value 1b
data modify storage scdi:config show_tag_title set value 1b
data modify storage scdi:config show_timer_above_head set value 0b
data modify storage scdi:config show_timer_text_display set value 1b
data modify storage scdi:config scan_inventory set value 1b
data modify storage scdi:config disable_firework_rocket set value 1b
data modify storage scdi:config disable_wind_charge set value 0b
data modify storage scdi:config disable_elytra set value 0b
data modify storage scdi:config disguise_targets set value []
data modify storage scdi:config proximity_tagging set value 0b
data modify storage scdi:config proximity_distance set value 6.0
data modify storage scdi:config proximity_retag_distance set value 6.0
data modify storage scdi:config placement_revert_radius set value 4
data modify storage scdi:config debug_custom_items set value 0b
data modify storage scdi:config debug_hit_messages set value 0b
data modify storage scdi:config passive_restore set value 1b
data modify storage scdi:config tag_attacker set value 1b
data modify storage scdi:config tag_victim set value 1b
data modify storage scdi:config team_tag_attacker set value 1b
data modify storage scdi:config team_tag_victim set value 0b
data modify storage scdi:config team_tag_proximity set value 0b
data modify storage scdi:config no_tag_on_one_shot_kill set value 0b
data modify storage scdi:config no_tag_victim_on_one_shot set value 1b
data modify storage scdi:config announce_one_shot set value 1b
data modify storage scdi:config one_shot_ignore_tag set value 0b
data modify storage scdi:config one_shot_cooldown_enabled set value 0b
data modify storage scdi:config one_shot_cooldown set value 200
data modify storage scdi:config combat_sound set value "minecraft:block.note_block.bit"
data modify storage scdi:config combat_pitch set value 0.5f
data modify storage scdi:config combat_volume set value 1.0f
data modify storage scdi:config safe_sound set value "minecraft:block.note_block.bit"
data modify storage scdi:config safe_pitch set value 1.0f
data modify storage scdi:config safe_volume set value 1.0f
data modify storage scdi:config firework_rocket_duration set value 0
data modify storage scdi:config wind_charge_duration set value 0
data modify storage scdi:config elytra_duration set value 0
data modify storage scdi:config allow_dummy_trigger set value 0b
data modify storage scdi:config dummy_tagging set value 1b
data modify storage scdi:config dummy_look_at_player set value 1b
data modify storage scdi:config dummy_look_range set value 10.0
data modify storage scdi:config dummy_pickup_items set value 0b
data modify storage scdi:config dummy_announce_one_shot set value 1b
data modify storage scdi:config dummy_one_shot_ignore_tag set value 0b
data modify storage scdi:config dummy_announce_time_to_kill set value 1b
data modify storage scdi:config dummy_dps_window set value 20
data modify storage scdi:config dummy_announce_cheated_death set value 0b
data modify storage scdi:config dummy_show_health set value 1b
data modify storage scdi:config dummy_regen set value 1b
data modify storage scdi:config dummy_regen_delay set value 100
data modify storage scdi:config dummy_regen_amount set value 1
data modify storage scdi:config dummy_immobile set value 1b
data modify storage scdi:config dummy_no_gravity set value 0b
data modify storage scdi:config dummy_max_health set value 1000
data modify storage scdi:config dummy_one_shot_damage set value 20
data modify storage scdi:config dummy_damage_numbers set value 1b
data modify storage scdi:config team_request_timeout set value 600
data modify storage scdi:config teleport_command set value "teleport"
data modify storage scdi:config timer_display_teleport_duration set value 3

# apply the display-related reset live, right now - same as show_timer_above_head_off's
# own menu function - instead of waiting for the next tag/reload to notice.
# the actual below_name release already happened above, gated on the
# pre-reset value.
kill @e[type=minecraft:text_display,tag=scdi_timer_display]
