# called with {equip_key,slot_arg,item,enchant} - only ever invoked once the
# caller has already confirmed enchant is non-empty via a plain (non-macro)
# condition, same reasoning as check_custom_item_mainhand_enchant.mcfunction.
$execute if data entity @s equipment.$(equip_key){id:"$(item)"} if data entity @s equipment.$(equip_key).components."minecraft:enchantments"."$(enchant)" unless data entity @s equipment.$(equip_key){components:{"minecraft:custom_data":{scdi:{null:1b}}}} run function scdi:nullify_equipment_slot {equip_key:"$(equip_key)",slot_arg:"$(slot_arg)",orig:"$(item)"}
