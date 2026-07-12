# rebuilt from scratch after conclusive proof (debug/diagnose_armor_real,
# tested 3 different /item modify syntax forms - bare single function, bare
# array, sequence-wrapped array - all 3 silently changed nothing on a real
# player's chest slot) that /item modify entity @s armor.chest simply does
# not work in this environment, in any form, full stop. switched to a
# direct NBT write instead: "data modify entity @s equipment.chest set
# value {...}" replaces the whole slot's item compound in one shot - the
# exact same technique apply_dummy_pickup_item.mcfunction and the
# "Clear armor" button already use successfully elsewhere in this pack, so
# it's proven to actually work for writing equipment, unlike /item modify.
$data modify entity @s equipment.chest set value {id:"$(item)",count:1,components:{"minecraft:custom_data":{"scdi":{"null":true,"orig":"$(orig)","snapshot":$(snapshot),"real_count":$(real_count)}},"minecraft:item_model":"$(model)","minecraft:custom_name":{"text":"$(name)","color":"$(name_color)","bold":$(name_bold),"italic":$(name_italic)},"minecraft:enchantment_glint_override":$(glint)}}
execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s [{"text":"[elytra] apply_nullify_armor done - chest now = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
