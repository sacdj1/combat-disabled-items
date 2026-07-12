# isolated test of component removal syntax, independent of the rest of the
# pack's logic: adds a custom_data tag to whatever's in your mainhand, then
# tries to remove it, and dumps the item's FULL component list both times so
# there's no ambiguity about whether "!key":{} actually clears the data or
# just leaves a harmless-looking but still-present patch entry behind.
# usage: /function scdi:debug/diagnose_removal
tellraw @s {"text":"[removal] adding a test custom_data tag...","color":"yellow"}
item modify entity @s weapon.mainhand {"function":"minecraft:set_components","components":{"minecraft:custom_data":{"scdi_test":{"marker":1b}}}}
tellraw @s [{"text":"[removal] full components AFTER ADD: ","color":"gray"},{"nbt":"SelectedItem.components","entity":"@s","interpret":false}]

tellraw @s {"text":"[removal] removing it via \"!minecraft:custom_data\":{}...","color":"yellow"}
item modify entity @s weapon.mainhand {"function":"minecraft:set_components","components":{"!minecraft:custom_data":{}}}
tellraw @s [{"text":"[removal] full components AFTER REMOVE: ","color":"gray"},{"nbt":"SelectedItem.components","entity":"@s","interpret":false}]

tellraw @s {"text":"[removal] DONE - the second dump should have NO custom_data entry at all, not even an empty one","color":"green"}
