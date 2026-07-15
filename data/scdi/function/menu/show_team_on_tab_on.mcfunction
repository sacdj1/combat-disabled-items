execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run data modify storage scdi:config show_team_on_tab set value 1b
execute if entity @s[level=2..] run scoreboard objectives setdisplay list scdi_team
execute if entity @s[level=2..] run function scdi:menu_sounds_display_show
