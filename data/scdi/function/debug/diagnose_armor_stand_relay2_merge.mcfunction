# the exact same macro merge command as apply_nullify_armor.mcfunction,
# split out here so diagnose_armor_stand_relay2.mcfunction can print
# before/after around it.
$execute as @e[type=minecraft:armor_stand,tag=scdi_relay2_test,limit=1,sort=nearest] run data merge entity @s {equipment:{chest:{id:"$(item)",count:1,components:{"minecraft:custom_data":{"scdi":{"null":true,"orig":"$(orig)","snapshot":$(snapshot),"real_count":$(real_count)}},"minecraft:item_model":"$(model)","minecraft:custom_name":{"text":"$(name)","color":"$(name_color)","bold":$(name_bold),"italic":$(name_italic)},"minecraft:enchantment_glint_override":$(glint)}}}}
