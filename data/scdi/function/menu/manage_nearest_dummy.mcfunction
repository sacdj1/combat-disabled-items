# op convenience button - bypasses allow_dummy_trigger (that gate only
# controls the PUBLIC /trigger ScdiDummyMenu access).
execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"No test dummy within 10 blocks of you.","color":"red"}
execute if entity @s[level=2..] if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run function scdi:dummy_menu_show
