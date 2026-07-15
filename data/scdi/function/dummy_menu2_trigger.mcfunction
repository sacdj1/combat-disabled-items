# fired via /trigger ScdiDummyMenu2 (any player, no op needed) - jumps
# straight to page 2 of the dummy trigger menu without going through page 1
# first. same allow_dummy_trigger gate and proximity check as
# dummy_menu_trigger.mcfunction (page 1).
execute unless data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"Dummy management is currently disabled by an admin.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"No test dummy within 10 blocks of you.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run function scdi:dummy_menu2_show
