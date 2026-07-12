# called with {index:N,orig:"minecraft:..."} - walks the whole list every
# time rather than stopping at the first match (no early-exit needed since
# lists here are short, and duplicate item entries are an edge case not worth
# guarding against - last match wins if that ever happens).
$execute unless data storage scdi:config disguise_targets[$(index)] run return 0
$execute if data storage scdi:config disguise_targets[$(index)]{item:"$(orig)"} if data storage scdi:config disguise_targets[$(index)].duration run execute store result score @s scdi_item_dur run data get storage scdi:config disguise_targets[$(index)].duration 1
$execute if data storage scdi:config disguise_targets[$(index)]{item:"$(orig)"} if data storage scdi:config disguise_targets[$(index)].duration if score @s scdi_item_dur matches 0 run scoreboard players operation @s scdi_item_dur = $duration scdi_const
scoreboard players add $dur_idx scdi_const 1
function scdi:get_effective_duration_custom_recursive
