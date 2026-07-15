# prints the FULL raw components NBT of whatever's in your mainhand, as
# text, so we can see exactly how a "removed" component patch is actually
# represented instead of guessing. usage: hold the item, then run this
# datapack function: scdi:debug/dump_mainhand_components
tellraw @s {"text":"[dump] id:","color":"yellow"}
tellraw @s [{"nbt":"SelectedItem.id","entity":"@s","interpret":false}]
tellraw @s {"text":"[dump] components:","color":"yellow"}
tellraw @s [{"nbt":"SelectedItem.components","entity":"@s","interpret":false}]
