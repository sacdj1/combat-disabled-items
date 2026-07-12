# called with {index:N} - /return exits once the index runs off the end of
# the list, same recursion pattern as check_custom_item_at_index.mcfunction
$execute unless data storage scdi:config disguise_targets[$(index)] run return 0
$tellraw @s ["",{"text":"  - ","color":"gray"},{"nbt":"disguise_targets[$(index)].item","storage":"scdi:config","interpret":false,"color":"yellow"},{"text":"  (scan inventory: ","color":"dark_gray"},{"nbt":"disguise_targets[$(index)].scan_inventory","storage":"scdi:config","interpret":false,"color":"yellow"},{"text":", requires enchant: ","color":"dark_gray"},{"nbt":"disguise_targets[$(index)].enchant","storage":"scdi:config","interpret":false,"color":"yellow"},{"text":")  ","color":"dark_gray"},{"text":"[Remove]","color":"red","underlined":true,"click_event":{"action":"run_command","command":"/function scdi:menu/remove_custom_item {index:$(index)}"},"hover_event":{"action":"show_text","value":"Remove this item from the list."}}]
scoreboard players add $custom_idx scdi_const 1
function scdi:menu_items_list_recursive
