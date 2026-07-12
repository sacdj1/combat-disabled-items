# called with {slot:"head"/"chest"/"legs"/"feet"} at @s = the dummy, from
# apply_drop_dummy_armor.mcfunction/apply_drop_all_dummy_items.mcfunction.
# only acts if that slot actually has something in it - "if data entity @s
# equipment.$(slot)" no-ops on an empty slot rather than matching air.
# captures the item's full NBT into storage first (components, durability,
# enchantments, name - whatever it had on), then hands off to
# apply_finish_drop_dummy_armor.mcfunction to actually spawn it. THEN clears
# the slot on the dummy itself - a real bug fixed earlier: the drop
# button/death handling used to copy the item onto a new entity but never
# actually remove it from the dummy, so it looked like nothing happened.
$execute if data entity @s equipment.$(slot) run data modify storage scdi:tmp7 item set from entity @s equipment.$(slot)
$execute if data entity @s equipment.$(slot) run data modify storage scdi:tmp7 slot set value "$(slot)"
$execute if data entity @s equipment.$(slot) positioned ~ ~1 ~ run function scdi:apply_finish_drop_dummy_armor with storage scdi:tmp7
$execute if data entity @s equipment.$(slot) run data remove entity @s equipment.$(slot)
