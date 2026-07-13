# tests whether /item replace onto an armor slot requires the item to carry
# a minecraft:equippable component - diagnose_armor_stand_relay2.mcfunction
# showed the merge onto the relay stand succeeds even with a plain
# minecraft:stick (the real disguise_item, no equippable component), but
# the subsequent item replace onto the PLAYER's armor.chest slot silently
# did nothing - unlike the earlier synthetic test using an actual
# chestplate (which inherently carries an equippable component), which DID
# work. this isolates that theory with a minimal, controlled case.
# usage: /function scdi:debug/diagnose_equippable_test
summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_equip_test"]}

tellraw @s {"text":"[equip-test] TEST 1: plain stick, no equippable component","color":"yellow"}
execute as @e[type=minecraft:armor_stand,tag=scdi_equip_test,limit=1,sort=nearest] run data merge entity @s {equipment:{chest:{id:"minecraft:stick",count:1}}}
tellraw @s [{"text":"[equip-test] player chest BEFORE = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
item replace entity @s armor.chest from entity @e[type=minecraft:armor_stand,tag=scdi_equip_test,limit=1,sort=nearest] armor.chest
tellraw @s [{"text":"[equip-test] player chest AFTER = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]

tellraw @s {"text":"[equip-test] TEST 2: same stick, WITH minecraft:equippable slot:chest component added","color":"yellow"}
execute as @e[type=minecraft:armor_stand,tag=scdi_equip_test,limit=1,sort=nearest] run data merge entity @s {equipment:{chest:{id:"minecraft:stick",count:1,components:{"minecraft:equippable":{slot:"chest"}}}}}
tellraw @s [{"text":"[equip-test] player chest BEFORE = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
item replace entity @s armor.chest from entity @e[type=minecraft:armor_stand,tag=scdi_equip_test,limit=1,sort=nearest] armor.chest
tellraw @s [{"text":"[equip-test] player chest AFTER = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]

kill @e[type=minecraft:armor_stand,tag=scdi_equip_test,limit=1,sort=nearest]
tellraw @s {"text":"[equip-test] DONE - if TEST 1 shows no change but TEST 2 does, the fix is adding minecraft:equippable to the disguise item's components in apply_nullify_armor.mcfunction.","color":"green"}
