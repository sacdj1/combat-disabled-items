# drops every dummy's items first (see apply_drop_all_dummy_items.mcfunction),
# then kills them all - same as any other way a dummy can "die".
execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] as @e[type=minecraft:mannequin,tag=scdi_dummy] at @s run function scdi:apply_drop_all_dummy_items
execute if entity @s[level=2..] run kill @e[type=minecraft:mannequin,tag=scdi_dummy]
execute if entity @s[level=2..] run kill @e[type=minecraft:text_display,tag=scdi_dummy_health_display]
execute if entity @s[level=2..] run tellraw @s {"text":"(✔) All test dummies removed (dropped their items first).","color":"green"}
execute if entity @s[level=2..] run function scdi:menu_misc_show
