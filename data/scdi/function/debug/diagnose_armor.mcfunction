# isolated test of the elytra/armor nullify path, mirroring diagnose_restore.mcfunction
# but for the chest slot instead of mainhand. usage: wear an elytra, then
# /function scdi:debug/diagnose_armor
tellraw @s {"text":"[armor] disable_elytra config:","color":"yellow"}
execute if data storage scdi:config {disable_elytra:1b} run tellraw @s {"text":"[armor]   disable_elytra: TRUE","color":"green"}
execute unless data storage scdi:config {disable_elytra:1b} run tellraw @s {"text":"[armor]   disable_elytra: FALSE - this is OFF by default, turn it on via /function scdi:menu (Disabled Items) or /data modify storage scdi:config disable_elytra set value 1b","color":"red"}

tellraw @s {"text":"[armor] BEFORE:","color":"yellow"}
tellraw @s [{"text":"[armor] chest slot item = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]

execute if predicate scdi:elytra_armor run tellraw @s {"text":"[armor] elytra_armor predicate: TRUE (a real elytra is worn)","color":"green"}
execute unless predicate scdi:elytra_armor run tellraw @s {"text":"[armor] elytra_armor predicate: FALSE - either nothing/not an elytra is worn, or it's already disguised. Note: only minecraft:elytra is a BUILT-IN armor target - any other armor piece (chestplate/helmet/leggings/boots) needs to be added as its own entry via /function scdi:menu/items, same as any other custom item.","color":"red"}

execute if predicate scdi:nulled_armor run tellraw @s {"text":"[armor] nulled_armor predicate: TRUE (already disguised)","color":"green"}
execute unless predicate scdi:nulled_armor run tellraw @s {"text":"[armor] nulled_armor predicate: FALSE (not disguised)","color":"green"}

tellraw @s {"text":"[armor] STEP 1: nullify_armor (only runs if disable_elytra is on and elytra_armor matched above)","color":"yellow"}
execute if data storage scdi:config {disable_elytra:1b} if predicate scdi:elytra_armor unless predicate scdi:nulled_armor run function scdi:nullify_armor
tellraw @s [{"text":"[armor] chest slot item = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false},{"text":" | model = ","color":"gray"},{"nbt":"equipment.chest.components.\"minecraft:item_model\"","entity":"@s","interpret":false}]

tellraw @s {"text":"[armor] STEP 2: restore_armor","color":"yellow"}
execute if predicate scdi:nulled_armor run function scdi:restore_armor
tellraw @s [{"text":"[armor] chest slot item = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false},{"text":" | full components = ","color":"gray"},{"nbt":"equipment.chest.components","entity":"@s","interpret":false}]

tellraw @s {"text":"[armor] DONE - if STEP 1 never disguised the chestplate, check the disable_elytra/elytra_armor lines above for why","color":"green"}
