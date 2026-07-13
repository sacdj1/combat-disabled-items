# isolates the two halves of the armor-stand relay technique
# (apply_nullify_armor.mcfunction) separately, since the live test showed
# the chest slot never actually changes: (1) does the data merge actually
# stick onto the STAND's own equipment, and (2) does item replace actually
# copy from the stand onto the player. usage: wear any chestplate, then
# /function scdi:debug/diagnose_armor_stand_relay
summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_relay_test"]}
tellraw @s [{"text":"[relay-test] stand chest BEFORE merge = ","color":"gray"},{"nbt":"equipment.chest","entity":"@e[type=minecraft:armor_stand,tag=scdi_relay_test,limit=1,sort=nearest]","interpret":false}]
execute as @e[type=minecraft:armor_stand,tag=scdi_relay_test,limit=1,sort=nearest] run data merge entity @s {equipment:{chest:{id:"minecraft:diamond_chestplate",count:1}}}
tellraw @s [{"text":"[relay-test] stand chest AFTER merge = ","color":"gray"},{"nbt":"equipment.chest","entity":"@e[type=minecraft:armor_stand,tag=scdi_relay_test,limit=1,sort=nearest]","interpret":false}]
tellraw @s [{"text":"[relay-test] player chest BEFORE replace = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
item replace entity @s armor.chest from entity @e[type=minecraft:armor_stand,tag=scdi_relay_test,limit=1,sort=nearest] armor.chest
tellraw @s [{"text":"[relay-test] player chest AFTER replace = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
kill @e[type=minecraft:armor_stand,tag=scdi_relay_test,limit=1,sort=nearest]
tellraw @s {"text":"[relay-test] DONE - compare the 4 lines above: if AFTER merge still shows nothing, the write onto the stand itself is what's failing. if AFTER merge shows diamond_chestplate but AFTER replace on the player didn't change, the copy-from-stand step is what's failing.","color":"green"}
