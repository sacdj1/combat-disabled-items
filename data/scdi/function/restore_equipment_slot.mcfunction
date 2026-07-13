# called with {equip_key,slot_arg} once check_restore_equipment_slot.mcfunction
# confirms it's needed. hands off to apply_restore_equipment_slot.mcfunction
# (the armor-stand relay technique) rather than apply_restore_hotbar_slot -
# see that file for why armor slots can't use the same /item modify
# approach genuine hotbar slots do. no fireworks-component capture needed
# here (unlike the hotbar version) - an armor slot can never hold a
# firework rocket or wind charge, only a genuine custom item rule's target.
$data modify storage scdi:tmp equip_key set value "$(equip_key)"
$data modify storage scdi:tmp slot_arg set value "$(slot_arg)"
data modify storage scdi:tmp orig set value "minecraft:leather_boots"
$execute if data entity @s equipment.$(equip_key).components."minecraft:custom_data".scdi.orig run data modify storage scdi:tmp orig set from entity @s equipment.$(equip_key).components."minecraft:custom_data".scdi.orig
$data modify storage scdi:tmp count set from entity @s equipment.$(equip_key).count
$execute if data entity @s equipment.$(equip_key).components."minecraft:custom_data".scdi.real_count run data modify storage scdi:tmp count set from entity @s equipment.$(equip_key).components."minecraft:custom_data".scdi.real_count
data modify storage scdi:tmp snapshot set value {}
$execute if data entity @s equipment.$(equip_key).components."minecraft:custom_data".scdi.snapshot run data modify storage scdi:tmp snapshot set from entity @s equipment.$(equip_key).components."minecraft:custom_data".scdi.snapshot
function scdi:apply_restore_equipment_slot with storage scdi:tmp
