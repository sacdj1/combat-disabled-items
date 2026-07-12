# rebuilt from scratch alongside apply_nullify_armor.mcfunction - /item
# modify and /loot replace both proved non-functional for armor.chest on a
# real player in this environment (see debug/diagnose_armor_real). direct
# NBT write instead: reconstructs a fresh elytra compound with the real
# captured snapshot (enchantments/trim/durability/name - whatever was
# really on it) merged in as its components, written straight into the
# equipment slot in one shot - the same proven-working technique as
# apply_nullify_armor.mcfunction.
$data modify entity @s equipment.chest set value {id:"minecraft:elytra",count:$(count),components:$(snapshot)}
execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s [{"text":"[elytra] apply_restore_armor done - chest now = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
