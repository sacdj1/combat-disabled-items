# per-dummy setting, no global default - see apply_check_dummy_hit2.mcfunction/
# apply_dummy_invincible_save.mcfunction/apply_dummy_invincible_max_health.mcfunction.
execute unless data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"Dummy management is currently disabled by an admin.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"No test dummy within 10 blocks of you.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] run scoreboard players set @s scdi_dummy_invincible 1
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] at @s run function scdi:apply_dummy_invincible_max_health with storage scdi:config
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"(✔) This dummy is now invincible.","color":"green"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run function scdi:dummy_menu_show
