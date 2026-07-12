# called with {slot:N,slot_arg:"..."} once check_restore_hotbar_slot.mcfunction
# confirms it's needed. see restore_mainhand.mcfunction for why this captures
# count/fireworks and uses /loot replace instead of /item modify set_item.
$data modify storage scdi:tmp slot_arg set value "$(slot_arg)"
data modify storage scdi:tmp orig set value "minecraft:firework_rocket"
$execute if data entity @s Inventory[{Slot:$(slot)b}].components."minecraft:custom_data".scdi.orig run data modify storage scdi:tmp orig set from entity @s Inventory[{Slot:$(slot)b}].components."minecraft:custom_data".scdi.orig
$data modify storage scdi:tmp count set from entity @s Inventory[{Slot:$(slot)b}].count
$execute if data entity @s Inventory[{Slot:$(slot)b}].components."minecraft:custom_data".scdi.real_count run data modify storage scdi:tmp count set from entity @s Inventory[{Slot:$(slot)b}].components."minecraft:custom_data".scdi.real_count
data modify storage scdi:tmp fireworks set value {"flight_duration":1,"explosions":[]}
$execute if data entity @s Inventory[{Slot:$(slot)b}].components."minecraft:fireworks" run data modify storage scdi:tmp fireworks set from entity @s Inventory[{Slot:$(slot)b}].components."minecraft:fireworks"
data modify storage scdi:tmp snapshot set value {}
$execute if data entity @s Inventory[{Slot:$(slot)b}].components."minecraft:custom_data".scdi.snapshot run data modify storage scdi:tmp snapshot set from entity @s Inventory[{Slot:$(slot)b}].components."minecraft:custom_data".scdi.snapshot
function scdi:apply_restore_hotbar_slot with storage scdi:tmp
