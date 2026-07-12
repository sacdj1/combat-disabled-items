# op convenience button - bypasses the allow_dummy_trigger gate entirely
# (that gate only controls the PUBLIC /trigger ScdiDummy access), since an
# op explicitly clicking this in the menu is a clear enough signal on its own.
execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] at @s summon minecraft:mannequin run function scdi:configure_new_dummy with storage scdi:config
execute if entity @s[level=2..] run tellraw @s {"text":"(✔) Test dummy spawned.","color":"green"}
execute if entity @s[level=2..] run function scdi:menu_misc_show
