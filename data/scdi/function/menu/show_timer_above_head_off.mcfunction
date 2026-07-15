execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run data modify storage scdi:config show_timer_above_head set value 0b
execute if entity @s[level=2..] run function scdi:apply_release_belowname with storage scdi:config
execute if entity @s[level=2..] run function scdi:menu_sounds_display_show
