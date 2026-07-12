# called with {index:N} - clicked from the [Remove] button in the items submenu
execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
$execute if entity @s[level=2..] run data remove storage scdi:config disguise_targets[$(index)]
execute if entity @s[level=2..] run function scdi:menu_items_show
