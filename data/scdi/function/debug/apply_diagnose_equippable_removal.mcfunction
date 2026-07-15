# called with {item,count,components} from diagnose_equippable_removal.mcfunction
# with storage scdi:tmp28 - split out because a macro function can't be
# invoked directly by a player via plain /function (no argument source).
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_diag_relay"]}
$execute as @e[type=minecraft:armor_stand,tag=scdi_diag_relay,limit=1,sort=nearest] run data merge entity @s {equipment:{offhand:{id:"$(item)",count:$(count),components:$(components)}}}
tellraw @s {"text":"[diag] relay stand's offhand components (after merge, BEFORE item replace):","color":"yellow"}
execute as @e[type=minecraft:armor_stand,tag=scdi_diag_relay,limit=1,sort=nearest] run tellraw @a [{"nbt":"equipment.offhand.components","entity":"@s","interpret":false}]
kill @e[type=minecraft:armor_stand,tag=scdi_diag_relay,limit=1,sort=nearest]
