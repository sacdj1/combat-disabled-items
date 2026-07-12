execute unless data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"Dummy management is currently disabled by an admin.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"No test dummy within 10 blocks of you.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] store result entity @s Health float 1 run attribute @s minecraft:max_health get
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] run scoreboard players set @s scdi_dummy_hit 0
# an invincible dummy's floor (apply_dummy_invincible_segment_topoff.mcfunction)
# has to reset back to max-20 too, not just raw Health - otherwise healing
# to full while the floor is still partway down from earlier segment cheats
# makes the display (raw_health - floor) show more than 20/20.
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1,scores={scdi_dummy_invincible=1..}] store result score @s scdi_dummy_invincible_floor run attribute @s minecraft:max_health get
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1,scores={scdi_dummy_invincible=1..}] run scoreboard players remove @s scdi_dummy_invincible_floor 20
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"(✔) Dummy healed to full.","color":"green"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run function scdi:dummy_menu_show
