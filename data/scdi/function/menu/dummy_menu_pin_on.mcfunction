# per-dummy setting, no global default - see apply_dummy_pin_tick.mcfunction/
# dummy_menu_show.mcfunction. captures the dummy's CURRENT position (at
# *1000 scale for sub-block precision - see load.mcfunction's
# scdi_dummy_pinned comment) as the spot it gets teleported back to every
# tick from now on, then flips the flag on.
execute unless data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"Dummy management is currently disabled by an admin.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"No test dummy within 10 blocks of you.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] store result score @s scdi_dummy_pin_x run data get entity @s Pos[0] 1000
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] store result score @s scdi_dummy_pin_y run data get entity @s Pos[1] 1000
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] store result score @s scdi_dummy_pin_z run data get entity @s Pos[2] 1000
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] run scoreboard players set @s scdi_dummy_pinned 1
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"(✔) This dummy is now pinned in place - immune to pistons, water, and anything else that would move it, not just combat knockback.","color":"green"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run function scdi:dummy_menu_show
