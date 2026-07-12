# called with {slot:N,slot_arg:"...",item:"minecraft:...",enchant:"minecraft:..."}
# - only ever invoked when the caller has already confirmed enchant is
# non-empty. see check_custom_item_mainhand_enchant.mcfunction for why that
# matters.
$execute if data entity @s Inventory[{Slot:$(slot)b,id:"$(item)"}] if data entity @s Inventory[{Slot:$(slot)b}].components."minecraft:enchantments"."$(enchant)" unless data entity @s Inventory[{Slot:$(slot)b,components:{"minecraft:custom_data":{scdi:{null:1b}}}}] run function scdi:nullify_hotbar_slot {slot:$(slot),slot_arg:"$(slot_arg)",orig:"$(item)"}
