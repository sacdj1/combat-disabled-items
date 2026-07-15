execute if data storage scdi:config {disable_firework_rocket:1b} if predicate scdi:firework_mainhand unless predicate scdi:nulled_mainhand run function scdi:nullify_mainhand {orig:"minecraft:firework_rocket"}
execute if data storage scdi:config {disable_firework_rocket:1b} if predicate scdi:firework_offhand unless predicate scdi:nulled_offhand run function scdi:nullify_offhand {orig:"minecraft:firework_rocket"}
execute if data storage scdi:config {disable_wind_charge:1b} if predicate scdi:windcharge_mainhand unless predicate scdi:nulled_mainhand run function scdi:nullify_mainhand {orig:"minecraft:wind_charge"}
execute if data storage scdi:config {disable_wind_charge:1b} if predicate scdi:windcharge_offhand unless predicate scdi:nulled_offhand run function scdi:nullify_offhand {orig:"minecraft:wind_charge"}
execute if data storage scdi:config {debug_custom_items:1b} if data storage scdi:config {disable_elytra:1b} run tellraw @s {"text":"[dbg-armor] disable_elytra: TRUE","color":"green"}
execute if data storage scdi:config {debug_custom_items:1b} unless data storage scdi:config {disable_elytra:1b} run tellraw @s {"text":"[dbg-armor] disable_elytra: FALSE","color":"red"}
execute if data storage scdi:config {debug_custom_items:1b} if predicate scdi:elytra_armor run tellraw @s {"text":"[dbg-armor] elytra_armor predicate (worn elytra detected): TRUE","color":"green"}
execute if data storage scdi:config {debug_custom_items:1b} unless predicate scdi:elytra_armor run tellraw @s {"text":"[dbg-armor] elytra_armor predicate (worn elytra detected): FALSE","color":"red"}
execute if data storage scdi:config {debug_custom_items:1b} if predicate scdi:nulled_armor run tellraw @s {"text":"[dbg-armor] nulled_armor (already disguised, blocks): TRUE","color":"red"}
execute if data storage scdi:config {debug_custom_items:1b} unless predicate scdi:nulled_armor run tellraw @s {"text":"[dbg-armor] nulled_armor (already disguised, blocks): FALSE","color":"green"}
execute if data storage scdi:config {disable_elytra:1b} if predicate scdi:elytra_armor unless predicate scdi:nulled_armor run function scdi:nullify_armor
execute if score $scan_mod scdi_const matches 0 if data storage scdi:config {scan_hotbar:1b} run function scdi:scan_hotbar
execute if score $scan_mod scdi_const matches 0 if data storage scdi:config {scan_extended_inventory:1b} run function scdi:scan_extended_inventory
execute if score $scan_mod scdi_const matches 0 run function scdi:check_custom_items
