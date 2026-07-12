# adds the nearest dummy to @s's team, for proximity-tagging exemption
# purposes (see check_proximity_apply.mcfunction) - same convention as
# player-to-player teaming (scdi_team = the team-founder's own scdi_id, see
# apply_team_confirm_established.mcfunction): assigns @s a team of their
# own first if they don't already have one, then copies it onto the dummy.
execute unless data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"Dummy management is currently disabled by an admin.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"No test dummy within 10 blocks of you.","color":"red"}
execute if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] unless score @s scdi_id matches 1.. run function scdi:assign_stopwatch_id
execute if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] unless score @s scdi_team matches 1.. run scoreboard players operation @s scdi_team = @s scdi_id
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run scoreboard players operation @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] scdi_team = @s scdi_team
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"(✔) Dummy added to your team - it won't proximity-tag you (or teammates) anymore.","color":"green"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run function scdi:dummy_menu_show
