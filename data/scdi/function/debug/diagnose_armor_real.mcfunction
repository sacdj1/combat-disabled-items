# isolates whether /item modify entity @s armor.chest is a TARGETING
# problem (armor.chest doesn't hit the real slot at all) or a SYNTAX
# problem (single-function works, but the multi-function JSON array chain
# apply_nullify_armor.mcfunction uses doesn't parse the way expected on
# this game version). usage: wear a real elytra, then
# /function scdi:debug/diagnose_armor_real
tellraw @s {"text":"[armor-real] BEFORE:","color":"yellow"}
tellraw @s [{"text":"[armor-real] chest id = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]

tellraw @s {"text":"[armor-real] STEP 1: SINGLE function, no array - item modify entity @s armor.chest {set_item barrier}","color":"yellow"}
item modify entity @s armor.chest {"function":"minecraft:set_item","item":"minecraft:barrier"}
tellraw @s [{"text":"[armor-real] chest id = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
item modify entity @s armor.chest {"function":"minecraft:set_item","item":"minecraft:elytra"}

tellraw @s {"text":"[armor-real] STEP 2: BARE ARRAY of 2 functions - [set_item diamond, set_count 5]","color":"yellow"}
item modify entity @s armor.chest [{"function":"minecraft:set_item","item":"minecraft:diamond"},{"function":"minecraft:set_count","count":5}]
tellraw @s [{"text":"[armor-real] chest id = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false},{"text":" count = ","color":"gray"},{"nbt":"equipment.chest.count","entity":"@s","interpret":false}]
item modify entity @s armor.chest {"function":"minecraft:set_item","item":"minecraft:elytra"}

tellraw @s {"text":"[armor-real] STEP 3: SEQUENCE-wrapped array - {function:sequence, functions:[set_item gold_ingot, set_count 3]}","color":"yellow"}
item modify entity @s armor.chest {"function":"minecraft:sequence","functions":[{"function":"minecraft:set_item","item":"minecraft:gold_ingot"},{"function":"minecraft:set_count","count":3}]}
tellraw @s [{"text":"[armor-real] chest id = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false},{"text":" count = ","color":"gray"},{"nbt":"equipment.chest.count","entity":"@s","interpret":false}]
item modify entity @s armor.chest {"function":"minecraft:set_item","item":"minecraft:elytra"}

tellraw @s {"text":"[armor-real] DONE - whichever of STEP 1/2/3 actually changed the chest id (and count, for 2/3) tells us which syntax form this game version accepts for armor.chest.","color":"green"}
