# entry point for the custom-items submenu. usage: /function scdi:menu/items
execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this menu.","color":"red"}
execute if entity @s[level=2..] run function scdi:menu_items_show
