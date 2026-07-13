# tests whether a NARROW /data modify write targeting a single nested
# component path on an ALREADY-EQUIPPED item (not replacing the whole item
# stack) is treated differently from the broad "equipment.chest set value
# {...}" write that's confirmed blocked (MC-123307, TEST D in
# debug/diagnose_write_methods.mcfunction) - never actually tested this
# narrower form. if this works, it's silent by construction: /data modify
# doesn't go through the same "equipment changed -> play equip_sound"
# detection /item replace and /item modify both do (that's a LivingEntity
# equip-tracking hook, not a generic NBT-write hook).
# usage: wear any leather chestplate, then
# /function scdi:debug/diagnose_data_modify_nested
tellraw @s [{"text":"[data-nested] chest dyed_color BEFORE = ","color":"gray"},{"nbt":"equipment.chest.components.\"minecraft:dyed_color\"","entity":"@s","interpret":false}]
data modify entity @s equipment.chest.components."minecraft:dyed_color" set value 16711680
tellraw @s [{"text":"[data-nested] chest dyed_color AFTER = ","color":"gray"},{"nbt":"equipment.chest.components.\"minecraft:dyed_color\"","entity":"@s","interpret":false}]
tellraw @s {"text":"[data-nested] DONE - did AFTER show 16711680 (red)? Also listen: did any sound play just now?","color":"green"}
