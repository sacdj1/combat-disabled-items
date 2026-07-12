execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run data modify storage scdi:config disable_firework_rocket set value 1b
execute if entity @s[level=2..] run function scdi:menu_disabled_items_show
