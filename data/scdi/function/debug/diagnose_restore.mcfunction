# runs a full nullify -> restore cycle on whatever's in your mainhand right
# now, printing item id, item_model, custom_name, glint override, and the
# fireworks component (flight duration/explosions) at every step, so there's
# no ambiguity about whether the restored item is a clean vanilla rocket.
# usage: /function scdi:debug/diagnose_restore
tellraw @s {"text":"[restore] BEFORE:","color":"yellow"}
tellraw @s [{"text":"[restore] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"},{"text":" | fireworks = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:fireworks\"","entity":"@s","interpret":false}]

tellraw @s {"text":"[restore] STEP 1: nullify_mainhand","color":"yellow"}
function scdi:nullify_mainhand {orig:"minecraft:firework_rocket"}
tellraw @s [{"text":"[restore] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"},{"text":" | model = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:item_model\"","entity":"@s","interpret":false},{"text":" | name = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:custom_name\"","entity":"@s","interpret":false},{"text":" | glint = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:enchantment_glint_override\"","entity":"@s","interpret":false}]

tellraw @s {"text":"[restore] STEP 2: restore_mainhand","color":"yellow"}
function scdi:restore_mainhand
tellraw @s [{"text":"[restore] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"},{"text":" | fireworks = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:fireworks\"","entity":"@s","interpret":false}]
tellraw @s [{"text":"[restore] FULL components dump: ","color":"gray"},{"nbt":"SelectedItem.components","entity":"@s","interpret":false}]

tellraw @s {"text":"[restore] DONE - the full components dump above should ONLY contain minecraft:fireworks (a genuine vanilla rocket has that much) and NOTHING with scdi in it","color":"green"}
