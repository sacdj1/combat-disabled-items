# tests whether /item modify with ONLY set_components (not set_item) can
# write to a player's already-equipped armor slot in place - the earlier
# diagnose_write_methods.mcfunction TEST C only tried set_item (which
# changes the item's actual type/registry id, a much more dupe-relevant
# operation), never a pure component mutation on an unchanged item type.
# if this works, it means the armor-stand relay (which does a full /item
# replace - equivalent to unequipping and re-equipping, triggering the
# equip sound every time) isn't actually necessary just to recolor an
# ALREADY-disguised item; only the initial disguise swap needs the relay.
# usage: wear any leather chestplate, then
# /function scdi:debug/diagnose_item_modify_components
tellraw @s [{"text":"[modify-test] chest dyed_color BEFORE = ","color":"gray"},{"nbt":"equipment.chest.components.\"minecraft:dyed_color\"","entity":"@s","interpret":false}]
item modify entity @s armor.chest {"function":"minecraft:set_components","components":{"minecraft:dyed_color":16711680}}
tellraw @s [{"text":"[modify-test] chest dyed_color AFTER = ","color":"gray"},{"nbt":"equipment.chest.components.\"minecraft:dyed_color\"","entity":"@s","interpret":false}]
tellraw @s {"text":"[modify-test] DONE - if AFTER shows 16711680 (red), set_components works in place. Also listen: did an equip sound play just now?","color":"green"}
