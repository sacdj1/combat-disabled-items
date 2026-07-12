# replicates nullify_mainhand.mcfunction's exact real path (config read +
# macro substitution), but prints the actual stored values and item state at
# every step, so we can see exactly what the macro path does differently
# from the hardcoded debug/diagnose test.
# usage: /function scdi:debug/diagnose_real
data modify storage scdi:tmp item set from storage scdi:config disguise_item
data modify storage scdi:tmp model set from storage scdi:config disguise_model

tellraw @s {"text":"[real] stored values:","color":"yellow"}
tellraw @s [{"text":"[real] item = ","color":"gray"},{"nbt":"item","storage":"scdi:tmp","interpret":false}]
tellraw @s [{"text":"[real] model = ","color":"gray"},{"nbt":"model","storage":"scdi:tmp","interpret":false}]

tellraw @s {"text":"[real] BEFORE:","color":"yellow"}
tellraw @s [{"text":"[real] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"}]

tellraw @s {"text":"[real] STEP 1: set_components null=true (hardcoded)","color":"yellow"}
item modify entity @s weapon.mainhand {"function":"minecraft:set_components","components":{"minecraft:custom_data":{"scdi":{"null":true}}}}
tellraw @s [{"text":"[real] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"}]

tellraw @s {"text":"[real] STEP 2: set_item via $(item) macro","color":"yellow"}
function scdi:debug/apply_diagnose_real_setitem with storage scdi:tmp
tellraw @s [{"text":"[real] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"}]

tellraw @s {"text":"[real] STEP 3: item_model via $(model) macro","color":"yellow"}
function scdi:debug/apply_diagnose_real_setmodel with storage scdi:tmp
tellraw @s [{"text":"[real] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"},{"text":" | model = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:item_model\"","entity":"@s","interpret":false}]

tellraw @s {"text":"[real] DONE","color":"green"}
