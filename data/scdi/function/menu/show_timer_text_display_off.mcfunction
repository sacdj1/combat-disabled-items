execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run data modify storage scdi:config show_timer_text_display set value 0b
execute if entity @s[level=2..] run kill @e[type=minecraft:text_display,tag=scdi_timer_display]
execute if entity @s[level=2..] run function scdi:menu_sounds_display_show
