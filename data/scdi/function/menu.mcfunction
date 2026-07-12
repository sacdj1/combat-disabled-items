# entry point for the admin config menu. usage: /function scdi:menu
execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this menu.","color":"red"}
execute if entity @s[level=2..] run function scdi:menu_show
