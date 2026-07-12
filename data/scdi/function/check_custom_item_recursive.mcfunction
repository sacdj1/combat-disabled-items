execute store result storage scdi:tmp2 index int 1 run scoreboard players get $custom_idx scdi_const
execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s [{"text":"[dbg] recursive entry, custom_idx score = ","color":"gray"},{"score":{"name":"$custom_idx","objective":"scdi_const"},"color":"aqua"}]
function scdi:check_custom_item_at_index with storage scdi:tmp2
