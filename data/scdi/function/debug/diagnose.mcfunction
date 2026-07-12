# self-contained diagnostic: runs the exact nullify sequence on whatever's in
# your mainhand right now, printing the item's id + custom_data.scdi.null
# after every single step, so there's no ambiguity about which result belongs
# to which command. usage: /function scdi:debug/diagnose
tellraw @s {"text":"[diagnose] BEFORE:","color":"yellow"}
tellraw @s [{"text":"[diagnose] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"}]

tellraw @s {"text":"[diagnose] STEP 1: set_components null=true","color":"yellow"}
item modify entity @s weapon.mainhand {"function":"minecraft:set_components","components":{"minecraft:custom_data":{"scdi":{"null":true}}}}
tellraw @s [{"text":"[diagnose] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"},{"text":" | null = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:custom_data\".scdi.null","entity":"@s","interpret":false}]

tellraw @s {"text":"[diagnose] STEP 2: set_item to gunpowder","color":"yellow"}
item modify entity @s weapon.mainhand {"function":"minecraft:set_item","item":"minecraft:gunpowder"}
tellraw @s [{"text":"[diagnose] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"},{"text":" | null = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:custom_data\".scdi.null","entity":"@s","interpret":false}]

tellraw @s {"text":"[diagnose] STEP 3: set_item back to firework_rocket","color":"yellow"}
item modify entity @s weapon.mainhand {"function":"minecraft:set_item","item":"minecraft:firework_rocket"}
tellraw @s [{"text":"[diagnose] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"},{"text":" | null = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:custom_data\".scdi.null","entity":"@s","interpret":false}]

tellraw @s {"text":"[diagnose] STEP 4: set_components null=false","color":"yellow"}
item modify entity @s weapon.mainhand {"function":"minecraft:set_components","components":{"minecraft:custom_data":{"scdi":{"null":false}}}}
tellraw @s [{"text":"[diagnose] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"},{"text":" | null = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:custom_data\".scdi.null","entity":"@s","interpret":false}]

tellraw @s {"text":"[diagnose] DONE - compare the 5 lines above","color":"green"}
