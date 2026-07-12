execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run data modify storage scdi:config dummy_one_shot_ignore_tag set value 0b
execute if entity @s[level=2..] run function scdi:menu_misc_show
