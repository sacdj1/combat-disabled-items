# called with {slot:N,slot_arg:"..."} - only proceed if that slot actually
# holds an un-nulled firework rocket (or, if enabled, an un-nulled wind
# charge or elytra). elytra here catches one sitting LOOSE in inventory,
# not worn - nullify_check.mcfunction's elytra_armor predicate only ever
# looks at the equipped chest slot, so an elytra in your backpack was
# never touched until the moment you actually equipped it (nullify_check
# would still catch it the very next tick either way, but this closes the
# gap proactively instead of relying on a same-tick race, and matches how
# firework rockets/wind charges already get disabled anywhere in the
# inventory, not just when held). regular inventory slots aren't
# "equipment", so this can use the same plain /item modify path as
# firework/wind charge - no armor-stand relay needed here.
$execute if data storage scdi:config {disable_firework_rocket:1b} if data entity @s Inventory[{Slot:$(slot)b,id:"minecraft:firework_rocket"}] unless data entity @s Inventory[{Slot:$(slot)b,components:{"minecraft:custom_data":{scdi:{null:1b}}}}] run function scdi:nullify_hotbar_slot {slot:$(slot),slot_arg:"$(slot_arg)",orig:"minecraft:firework_rocket"}
$execute if data storage scdi:config {disable_wind_charge:1b} if data entity @s Inventory[{Slot:$(slot)b,id:"minecraft:wind_charge"}] unless data entity @s Inventory[{Slot:$(slot)b,components:{"minecraft:custom_data":{scdi:{null:1b}}}}] run function scdi:nullify_hotbar_slot {slot:$(slot),slot_arg:"$(slot_arg)",orig:"minecraft:wind_charge"}
$execute if data storage scdi:config {disable_elytra:1b} if data entity @s Inventory[{Slot:$(slot)b,id:"minecraft:elytra"}] unless data entity @s Inventory[{Slot:$(slot)b,components:{"minecraft:custom_data":{scdi:{null:1b}}}}] run function scdi:nullify_hotbar_slot {slot:$(slot),slot_arg:"$(slot_arg)",orig:"minecraft:elytra"}
