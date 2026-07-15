# see apply_restore_mainhand.mcfunction for the full story on why the
# "anything else" (custom item) case is rebuilt fresh on a relay entity
# instead of an in-place item modify with negated component keys - same
# fix, mirrored here (this file never got it at the time either).
execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run loot replace entity @s weapon.offhand loot scdi:blank_wind_charge
execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run loot replace entity @s weapon.offhand loot scdi:blank_firework_rocket
$execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run item modify entity @s weapon.offhand {"function":"minecraft:set_count","count":$(count)}
$execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run item modify entity @s weapon.offhand [{"function":"minecraft:set_count","count":$(count)},{"function":"minecraft:set_components","components":{"minecraft:fireworks":$(fireworks)}}]
execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run return 0
execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run return 0
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_restore_relay"]}
$execute as @e[type=minecraft:armor_stand,tag=scdi_restore_relay,limit=1,sort=nearest] run data merge entity @s {equipment:{offhand:{id:"$(orig)",count:$(count),components:$(snapshot)}}}
item replace entity @s weapon.offhand from entity @e[type=minecraft:armor_stand,tag=scdi_restore_relay,limit=1,sort=nearest] weapon.offhand
kill @e[type=minecraft:armor_stand,tag=scdi_restore_relay,limit=1,sort=nearest]
