# offhand lives in its own top-level "equipment" compound in this version, not
# the legacy Inventory[] list (confirmed via decompiling EntityEquipment/
# PlayerEquipment) - see restore_mainhand.mcfunction for why this captures
# count/fireworks and uses /loot replace instead of /item modify set_item +
# component removal.
data modify storage scdi:tmp orig set value "minecraft:firework_rocket"
execute if data entity @s equipment.offhand.components."minecraft:custom_data".scdi.orig run data modify storage scdi:tmp orig set from entity @s equipment.offhand.components."minecraft:custom_data".scdi.orig
data modify storage scdi:tmp count set from entity @s equipment.offhand.count
execute if data entity @s equipment.offhand.components."minecraft:custom_data".scdi.real_count run data modify storage scdi:tmp count set from entity @s equipment.offhand.components."minecraft:custom_data".scdi.real_count
data modify storage scdi:tmp fireworks set value {"flight_duration":1,"explosions":[]}
execute if data entity @s equipment.offhand.components."minecraft:fireworks" run data modify storage scdi:tmp fireworks set from entity @s equipment.offhand.components."minecraft:fireworks"
data modify storage scdi:tmp snapshot set value {}
execute if data entity @s equipment.offhand.components."minecraft:custom_data".scdi.snapshot run data modify storage scdi:tmp snapshot set from entity @s equipment.offhand.components."minecraft:custom_data".scdi.snapshot
function scdi:apply_restore_offhand with storage scdi:tmp
