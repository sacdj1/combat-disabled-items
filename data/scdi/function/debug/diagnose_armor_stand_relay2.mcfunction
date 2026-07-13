# same idea as diagnose_armor_stand_relay.mcfunction, but uses the REAL
# elytra-disguise payload (captured the exact same way
# nullify_armor.mcfunction does) instead of a synthetic diamond_chestplate -
# the synthetic test proved the relay TECHNIQUE itself works, so this one
# narrows down whether the real macro-substituted payload (custom_data,
# snapshot, name/model/glint fields) is what's actually breaking it.
# usage: wear a real elytra, then
# /function scdi:debug/diagnose_armor_stand_relay2
data modify storage scdi:tmp orig set value "minecraft:elytra"
data modify storage scdi:tmp snapshot set value {}
execute if data entity @s equipment.chest.components run data modify storage scdi:tmp snapshot set from entity @s equipment.chest.components
data modify storage scdi:tmp real_count set from entity @s equipment.chest.count
data modify storage scdi:tmp item set from storage scdi:config disguise_item
data modify storage scdi:tmp model set from storage scdi:config disguise_model
data modify storage scdi:tmp name set from storage scdi:config disguise_name
data modify storage scdi:tmp name_color set from storage scdi:config disguise_name_color
data modify storage scdi:tmp name_bold set from storage scdi:config disguise_name_bold
data modify storage scdi:tmp name_italic set from storage scdi:config disguise_name_italic
data modify storage scdi:tmp glint set from storage scdi:config disguise_glint

tellraw @s [{"text":"[relay2] scdi:tmp payload = ","color":"gray"},{"nbt":"","storage":"scdi:tmp","interpret":false}]

execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_relay2_test"]}
tellraw @s [{"text":"[relay2] stand chest BEFORE merge = ","color":"gray"},{"nbt":"equipment.chest","entity":"@e[type=minecraft:armor_stand,tag=scdi_relay2_test,limit=1,sort=nearest]","interpret":false}]
function scdi:debug/diagnose_armor_stand_relay2_merge with storage scdi:tmp
tellraw @s [{"text":"[relay2] stand chest AFTER merge = ","color":"gray"},{"nbt":"equipment.chest","entity":"@e[type=minecraft:armor_stand,tag=scdi_relay2_test,limit=1,sort=nearest]","interpret":false}]
tellraw @s [{"text":"[relay2] player chest BEFORE replace = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
item replace entity @s armor.chest from entity @e[type=minecraft:armor_stand,tag=scdi_relay2_test,limit=1,sort=nearest] armor.chest
tellraw @s [{"text":"[relay2] player chest AFTER replace = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
kill @e[type=minecraft:armor_stand,tag=scdi_relay2_test,limit=1,sort=nearest]
tellraw @s {"text":"[relay2] DONE","color":"green"}
