# disables the worn elytra while tagged, same idea as firework rockets/wind
# charges. unlike those, elytra commonly carries real player data worth
# keeping (Unbreaking/Mending, custom name, trim, durability) - so instead of
# capturing just one known field, this snapshots the item's ENTIRE explicit
# "components" patch before disguising and stashes it inside the disguised
# item's own custom_data. on restore, that whole snapshot gets reapplied in
# one shot, which generically preserves everything about the original item
# regardless of what was on it. "equipment.chest" is the correct NBT data
# path for these /data reads - NOT the same as "armor.chest", the separate
# /item and /loot command slot-argument name used in
# apply_nullify_armor.mcfunction/apply_restore_armor.mcfunction. mixing the
# two up was the root cause of every earlier failure here (equipment.chest
# is a fatal "Unknown slot" parse error for /item and /loot commands on this
# game version, confirmed via the server log's function-load errors).
data modify storage scdi:tmp orig set value "minecraft:elytra"
data modify storage scdi:tmp snapshot set value {}
execute if data entity @s equipment.chest.components run data modify storage scdi:tmp snapshot set from entity @s equipment.chest.components
data modify storage scdi:tmp real_count set from entity @s equipment.chest.count
data modify storage scdi:tmp item set from storage scdi:config disguise_item
data modify storage scdi:tmp model set from storage scdi:config disguise_model
data modify storage scdi:tmp armor_model set from storage scdi:config disguise_armor_model
data modify storage scdi:tmp name set from storage scdi:config disguise_name
data modify storage scdi:tmp name_color set from storage scdi:config disguise_name_color
data modify storage scdi:tmp name_bold set from storage scdi:config disguise_name_bold
data modify storage scdi:tmp name_italic set from storage scdi:config disguise_name_italic
data modify storage scdi:tmp glint set from storage scdi:config disguise_glint
execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s [{"text":"[elytra] nullify_armor: chest before = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false},{"text":" -> disguising as ","color":"gray"},{"nbt":"item","storage":"scdi:tmp","interpret":false}]
function scdi:apply_nullify_armor with storage scdi:tmp
