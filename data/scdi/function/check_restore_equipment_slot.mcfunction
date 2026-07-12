# called with {equip_key:"head/chest/legs/feet",slot_arg:"equipment.head/..."} -
# only proceed if that equipment slot holds a nulled item. see
# check_custom_item_equipment_slot.mcfunction for why equipment.<key> is used
# instead of the legacy Inventory[{Slot:100-103b}] convention.
$execute if data entity @s equipment.$(equip_key){components:{"minecraft:custom_data":{scdi:{null:1b}}}} run function scdi:restore_equipment_slot {equip_key:"$(equip_key)",slot_arg:"$(slot_arg)"}
