# restore any nulled item currently equipped in mainhand/offhand - a no-op if
# there isn't one. called both at the exact moment combat ends, and every tick
# as a safety net for anyone not currently in combat (e.g. an item that got
# moved out of hand during combat and re-equipped only after combat ended)
execute if predicate scdi:nulled_mainhand run function scdi:restore_mainhand
execute if predicate scdi:nulled_offhand run function scdi:restore_offhand
execute if predicate scdi:nulled_armor run function scdi:restore_armor

# custom items (from disguise_targets) equipped in armor slots - checked
# separately from nulled_armor above since that's elytra-specific (and must
# run first, so a real elytra never gets picked up by this generic path).
# armor reads live in the "equipment" NBT compound (equip_key above), not
# the legacy Inventory[] list - see check_restore_equipment_slot.mcfunction.
# slot_arg is "armor.<key>", the separate /item and /loot command's
# item_slot argument name - see check_custom_item_slots.mcfunction.
function scdi:check_restore_equipment_slot {equip_key:"head",slot_arg:"armor.head"}
function scdi:check_restore_equipment_slot {equip_key:"chest",slot_arg:"armor.chest"}
function scdi:check_restore_equipment_slot {equip_key:"legs",slot_arg:"armor.legs"}
function scdi:check_restore_equipment_slot {equip_key:"feet",slot_arg:"armor.feet"}

execute if data storage scdi:config {scan_inventory:1b} run function scdi:restore_inventory
