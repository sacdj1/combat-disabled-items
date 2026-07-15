# called with {item,count,components} from repair_broken_equippable.mcfunction
# with storage scdi:tmp27 - split out because a macro function can't be
# invoked directly by a player via plain /function (no argument source),
# only from another function via "with storage".
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_repair_relay"]}
$execute as @e[type=minecraft:armor_stand,tag=scdi_repair_relay,limit=1,sort=nearest] run data merge entity @s {equipment:{mainhand:{id:"$(item)",count:$(count),components:$(components)}}}
item replace entity @s weapon.mainhand from entity @e[type=minecraft:armor_stand,tag=scdi_repair_relay,limit=1,sort=nearest] weapon.mainhand
kill @e[type=minecraft:armor_stand,tag=scdi_repair_relay,limit=1,sort=nearest]
tellraw @s {"text":"[repair] Done - try equipping it now.","color":"green"}
