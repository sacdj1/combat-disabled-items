# only the DEFAULT applied to dummies spawned from now on (see
# configure_new_dummy.mcfunction) - immobility is a per-dummy setting, see
# menu/dummy_menu_immobile_on.mcfunction/_off for toggling an existing one.
execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run data modify storage scdi:config dummy_immobile set value 0b
execute if entity @s[level=2..] run function scdi:menu_misc_show
