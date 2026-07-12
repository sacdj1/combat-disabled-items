# called with {orig:"minecraft:..."} - resolves the disable duration (ms) for
# whichever real item a disguise is hiding into the @s scdi_item_dur score:
# a per-item override if one's set, else the global $duration. the 3 built-in
# items check their own dedicated config key directly; anything else is
# assumed to be a custom disguise_targets entry and falls back to a reverse
# lookup by item id (see get_effective_duration_custom.mcfunction).
$data modify storage scdi:tmp5 orig set value "$(orig)"
scoreboard players operation @s scdi_item_dur = $duration scdi_const
execute if data storage scdi:tmp5 {orig:"minecraft:firework_rocket"} run execute store result score @s scdi_item_dur run data get storage scdi:config firework_rocket_duration 1
execute if data storage scdi:tmp5 {orig:"minecraft:firework_rocket"} if score @s scdi_item_dur matches 0 run scoreboard players operation @s scdi_item_dur = $duration scdi_const
execute if data storage scdi:tmp5 {orig:"minecraft:wind_charge"} run execute store result score @s scdi_item_dur run data get storage scdi:config wind_charge_duration 1
execute if data storage scdi:tmp5 {orig:"minecraft:wind_charge"} if score @s scdi_item_dur matches 0 run scoreboard players operation @s scdi_item_dur = $duration scdi_const
execute if data storage scdi:tmp5 {orig:"minecraft:elytra"} run execute store result score @s scdi_item_dur run data get storage scdi:config elytra_duration 1
execute if data storage scdi:tmp5 {orig:"minecraft:elytra"} if score @s scdi_item_dur matches 0 run scoreboard players operation @s scdi_item_dur = $duration scdi_const
execute unless data storage scdi:tmp5 {orig:"minecraft:firework_rocket"} unless data storage scdi:tmp5 {orig:"minecraft:wind_charge"} unless data storage scdi:tmp5 {orig:"minecraft:elytra"} run function scdi:get_effective_duration_custom
