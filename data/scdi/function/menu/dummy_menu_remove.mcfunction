# drops the nearest dummy's items first (see
# apply_drop_all_dummy_items.mcfunction), then kills it - same as any other
# way a dummy can "die".
execute unless data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"Dummy management is currently disabled by an admin.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"No test dummy within 10 blocks of you.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] at @s run function scdi:apply_drop_all_dummy_items
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} at @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] run kill @e[type=minecraft:text_display,tag=scdi_dummy_health_display,distance=..3]
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} run kill @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1]
execute if data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"(✔) Nearest dummy removed (dropped its items first).","color":"green"}
