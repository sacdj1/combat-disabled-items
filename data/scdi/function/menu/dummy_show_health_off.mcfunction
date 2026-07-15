execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run data modify storage scdi:config dummy_show_health set value 0b
execute if entity @s[level=2..] run kill @e[type=minecraft:text_display,tag=scdi_dummy_health_display]
execute if entity @s[level=2..] run function scdi:menu_misc2_show
