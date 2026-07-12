# isolated, step-by-step test of the custom-item pipeline for whatever's in
# your mainhand right now. dumps the raw list, tests the /execute if items
# syntax directly (hardcoded, not macro), tests the enchantment NBT read,
# then runs the real chain and shows the item before/after.
# usage: hold the item, then /function scdi:debug/diagnose_custom
tellraw @s {"text":"[custom] disguise_targets list:","color":"yellow"}
tellraw @s [{"text":"[custom] ","color":"gray"},{"nbt":"disguise_targets","storage":"scdi:config","interpret":false}]

tellraw @s {"text":"[custom] BEFORE:","color":"yellow"}
tellraw @s [{"text":"[custom] item = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"},{"text":" | enchantments = ","color":"gray"},{"nbt":"SelectedItem.components.\"minecraft:enchantments\"","entity":"@s","interpret":false}]

tellraw @s {"text":"[custom] STEP 1a: /execute if items (the method that turned out NOT to work)","color":"yellow"}
execute if items entity @s weapon.mainhand minecraft:mace run tellraw @s {"text":"[custom]   if items: MATCHED","color":"green"}
execute unless items entity @s weapon.mainhand minecraft:mace run tellraw @s {"text":"[custom]   if items: did NOT match","color":"red"}

tellraw @s {"text":"[custom] STEP 1b: if data entity SelectedItem{id:...} (the method now actually used)","color":"yellow"}
execute if data entity @s SelectedItem{id:"minecraft:mace"} run tellraw @s {"text":"[custom]   if data: MATCHED","color":"green"}
execute unless data entity @s SelectedItem{id:"minecraft:mace"} run tellraw @s {"text":"[custom]   if data: did NOT match","color":"red"}

tellraw @s {"text":"[custom] STEP 3: nulled_mainhand predicate right now","color":"yellow"}
execute if predicate scdi:nulled_mainhand run tellraw @s {"text":"[custom]   nulled_mainhand: TRUE (already disguised)","color":"green"}
execute unless predicate scdi:nulled_mainhand run tellraw @s {"text":"[custom]   nulled_mainhand: FALSE (not disguised)","color":"green"}

tellraw @s {"text":"[custom] STEP 4: running the real check_custom_items chain","color":"yellow"}
function scdi:check_custom_items
tellraw @s [{"text":"[custom] item after check_custom_items = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s"},{"text":" | full components = ","color":"gray"},{"nbt":"SelectedItem.components","entity":"@s","interpret":false}]

tellraw @s {"text":"[custom] DONE","color":"green"}
