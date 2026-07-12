# called with {slot:N,slot_arg:"...",item:"minecraft:...",enchant:"..." or ""}
# - only proceed if that slot actually holds an un-nulled instance of this
# specific custom item, and (if enchant is set) it also has that enchantment.
# stash enchant into storage first since a plain "if data storage ... {enchant:""}"
# check can't test a macro parameter directly, only stored data.
$data modify storage scdi:tmp2 slot set value $(slot)
$data modify storage scdi:tmp2 slot_arg set value "$(slot_arg)"
$data modify storage scdi:tmp2 item set value "$(item)"
$data modify storage scdi:tmp2 enchant set value "$(enchant)"
$execute if data entity @s Inventory[{Slot:$(slot)b,id:"$(item)"}] if data storage scdi:tmp2 {enchant:""} unless data entity @s Inventory[{Slot:$(slot)b,components:{"minecraft:custom_data":{scdi:{null:1b}}}}] run function scdi:nullify_hotbar_slot {slot:$(slot),slot_arg:"$(slot_arg)",orig:"$(item)"}
$execute if data entity @s Inventory[{Slot:$(slot)b,id:"$(item)"}] unless data storage scdi:tmp2 {enchant:""} unless data entity @s Inventory[{Slot:$(slot)b,components:{"minecraft:custom_data":{scdi:{null:1b}}}}] run function scdi:check_custom_item_hotbar_slot_enchant with storage scdi:tmp2
