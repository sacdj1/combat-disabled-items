execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run tellraw @s {"text":"[!] Warning: below_name is a single slot shared by the whole world - this replaces whatever objective is currently shown there (another datapack/plugin's display, if any) for as long as this stays on. Turning it back off releases the slot again, but does NOT restore whatever was there before.","color":"gold"}
execute if entity @s[level=2..] run data modify storage scdi:config show_timer_above_head set value 1b
execute if entity @s[level=2..] run scoreboard objectives setdisplay below_name scdi_sec
execute if entity @s[level=2..] run function scdi:menu_sounds_display_show
