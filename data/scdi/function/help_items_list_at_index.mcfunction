# called with {index:N} - /return exits once the index runs off the end of
# the list, same recursion pattern as check_custom_item_at_index.mcfunction.
# uses a dedicated $help_idx counter and scdi:tmp6 storage, separate from
# every other recursive walk in the pack, so /help can never collide with
# the live nullify/restore/menu walks even if run mid-tick.
$execute unless data storage scdi:config disguise_targets[$(index)] run return 0
$tellraw @s ["",{"text":"  - ","color":"gray"},{"nbt":"disguise_targets[$(index)].item","storage":"scdi:config","interpret":false,"color":"yellow"}]
scoreboard players add $help_idx scdi_const 1
function scdi:help_items_list_recursive
