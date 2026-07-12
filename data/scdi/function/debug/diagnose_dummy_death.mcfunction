# isolates whether the dummy's drop-on-death path itself works, independent
# of whether a real hit ever actually brings its Health down to 0 - forces
# Health to near-zero directly, then calls apply_check_dummy_hit.mcfunction
# exactly as on_attacked_entity.mcfunction would. usage: stand within 6
# blocks of a spawned dummy wearing some armor, then
# /function scdi:debug/diagnose_dummy_death
execute unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..6] run tellraw @s {"text":"[dummy-death] No dummy within 6 blocks.","color":"red"}

execute as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..6,sort=nearest,limit=1] run tellraw @s [{"text":"[dummy-death] Health before = ","color":"gray"},{"nbt":"Health","entity":"@s","interpret":false}]
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..6,sort=nearest,limit=1] run tellraw @s [{"text":"[dummy-death] chest before = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]

tellraw @s {"text":"[dummy-death] STEP: forcing Health to 0.5, then calling apply_check_dummy_hit directly","color":"yellow"}
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..6,sort=nearest,limit=1] run data modify entity @s Health set value 0.5f
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..6,sort=nearest,limit=1] at @s run function scdi:apply_check_dummy_hit

execute unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..6] run tellraw @s {"text":"[dummy-death] dummy is GONE - kill worked.","color":"green"}
execute if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..6] run tellraw @s {"text":"[dummy-death] dummy STILL EXISTS - apply_check_dummy_hit did not remove it.","color":"red"}
execute if entity @e[type=item,distance=..6] run tellraw @s {"text":"[dummy-death] found dropped item entity(s) nearby - drop worked.","color":"green"}
execute unless entity @e[type=item,distance=..6] run tellraw @s {"text":"[dummy-death] no dropped items found nearby.","color":"red"}

tellraw @s {"text":"[dummy-death] DONE.","color":"green"}
