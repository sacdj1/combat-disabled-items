# per-dummy setting, no global default - see apply_check_dummy_hit2.mcfunction/
# apply_dummy_invincible_save.mcfunction/apply_dummy_invincible_max_health.mcfunction.
# shrinks max_health back down to a normal, realistic-target 20 (vanilla's
# own mannequin default - the same value a freshly spawned, never-toggled
# dummy already has) and heals to that new max, undoing the large buffer
# invincible mode applies - no macro needed here since 20 is a fixed literal,
# not something pulled from config.
execute unless data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"Dummy management is currently disabled by an admin.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"No test dummy within 10 blocks of you.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] run scoreboard players reset @s scdi_dummy_invincible
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] run scoreboard players reset @s scdi_dummy_invincible_floor
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] at @s run attribute @s minecraft:max_health base set 20
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] at @s store result entity @s Health float 1 run attribute @s minecraft:max_health get
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"(✔) This dummy is mortal again.","color":"green"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run function scdi:dummy_menu_show
