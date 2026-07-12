execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run data modify storage scdi:config show_disabled_text set value 1b
execute if entity @s[level=2..] run function scdi:menu_sounds_display_show
