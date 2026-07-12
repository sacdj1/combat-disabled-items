# called with {index:N} - /return exits this whole function call chain the
# instant the index runs off the end of the list, which is how the recursion
# terminates.
$execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s [{"text":"[dbg] at_index called with index=","color":"gray"},{"text":"$(index)","color":"aqua"}]
$execute if data storage scdi:config {debug_custom_items:1b} unless data storage scdi:config disguise_targets[$(index)] run tellraw @s {"text":"[dbg] at_index: out of bounds, returning","color":"gray"}
$execute unless data storage scdi:config disguise_targets[$(index)] run return 0
$data modify storage scdi:tmp2 item set from storage scdi:config disguise_targets[$(index)].item
$data modify storage scdi:tmp2 scan_inv set from storage scdi:config disguise_targets[$(index)].scan_inventory
data modify storage scdi:tmp2 enchant set value ""
$execute if data storage scdi:config disguise_targets[$(index)].enchant run data modify storage scdi:tmp2 enchant set from storage scdi:config disguise_targets[$(index)].enchant
function scdi:check_custom_item_slots with storage scdi:tmp2
execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s {"text":"[dbg] at_index: check_custom_item_slots returned, incrementing","color":"gray"}
scoreboard players add $custom_idx scdi_const 1
execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s {"text":"[dbg] at_index: about to recurse again","color":"gray"}
function scdi:check_custom_item_recursive
