# called with {equip_key:"head/chest/legs/feet",slot_arg:"equipment.head/...",item:"minecraft:...",enchant:"..." or ""}
# - offhand/armor moved OUT of the legacy Inventory[] list into their own
# top-level "equipment" compound (keyed by slot name) in this version -
# confirmed via decompiling EntityEquipment/PlayerEquipment: mainhand still
# routes through Inventory's SelectedItem, but every other equipment slot
# lives under equipment.<key> instead. the old Inventory[{Slot:100-103b}]
# convention silently matches nothing now, which is why armor-slot custom
# items never got disabled.
$data modify storage scdi:tmp2 equip_key set value "$(equip_key)"
$data modify storage scdi:tmp2 slot_arg set value "$(slot_arg)"
$data modify storage scdi:tmp2 item set value "$(item)"
$data modify storage scdi:tmp2 enchant set value "$(enchant)"
$execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s ["",{"text":"[dbg] checking ","color":"gray"},{"text":"$(equip_key)","color":"aqua"},{"text":" for ","color":"gray"},{"text":"$(item)","color":"yellow"}]
$execute if data storage scdi:config {debug_custom_items:1b} if data entity @s equipment.$(equip_key){id:"$(item)"} run tellraw @s {"text":"[dbg]   id match: TRUE","color":"green"}
$execute if data storage scdi:config {debug_custom_items:1b} unless data entity @s equipment.$(equip_key){id:"$(item)"} run tellraw @s {"text":"[dbg]   id match: FALSE","color":"red"}
$execute if data storage scdi:config {debug_custom_items:1b} if data entity @s equipment.$(equip_key){components:{"minecraft:custom_data":{scdi:{null:1b}}}} run tellraw @s {"text":"[dbg]   already nulled: TRUE (blocks nullify)","color":"red"}
$execute if data storage scdi:config {debug_custom_items:1b} unless data entity @s equipment.$(equip_key){components:{"minecraft:custom_data":{scdi:{null:1b}}}} run tellraw @s {"text":"[dbg]   already nulled: FALSE","color":"green"}
$execute if data entity @s equipment.$(equip_key){id:"$(item)"} if data storage scdi:tmp2 {enchant:""} unless data entity @s equipment.$(equip_key){components:{"minecraft:custom_data":{scdi:{null:1b}}}} run function scdi:nullify_equipment_slot {equip_key:"$(equip_key)",slot_arg:"$(slot_arg)",orig:"$(item)"}
execute unless data storage scdi:tmp2 {enchant:""} run function scdi:check_custom_item_equipment_slot_enchant with storage scdi:tmp2
