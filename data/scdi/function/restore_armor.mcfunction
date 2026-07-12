# pulls the snapshot back out of the disguised item's own custom_data (see
# nullify_armor.mcfunction) before it gets replaced. "equipment.chest" is
# the correct NBT data-path name for these /data reads - see
# nullify_armor.mcfunction for why that's distinct from "armor.chest".
data modify storage scdi:tmp count set from entity @s equipment.chest.count
execute if data entity @s equipment.chest.components."minecraft:custom_data".scdi.real_count run data modify storage scdi:tmp count set from entity @s equipment.chest.components."minecraft:custom_data".scdi.real_count
data modify storage scdi:tmp snapshot set value {}
execute if data entity @s equipment.chest.components."minecraft:custom_data".scdi.snapshot run data modify storage scdi:tmp snapshot set from entity @s equipment.chest.components."minecraft:custom_data".scdi.snapshot
execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s [{"text":"[elytra] restore_armor: chest before = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
function scdi:apply_restore_armor with storage scdi:tmp
