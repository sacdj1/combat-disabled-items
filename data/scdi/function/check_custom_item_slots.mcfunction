# called with {item:"minecraft:...",scan_inv:1b/0b,enchant:"minecraft:..." or ""}
# from check_custom_item_at_index.mcfunction. enchant empty = match any
# instance of the item; enchant set = only match if it also has that
# specific enchantment (any level). matches via plain "if data entity"
# NBT checks - same proven pattern used everywhere else in this pack -
# instead of /execute if items, which turned out to never actually be
# matching (confirmed by reading the world's command_storage.dat directly:
# nullify_mainhand was never once called with a custom item's orig).
$execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s ["",{"text":"[dbg] checking mainhand for ","color":"gray"},{"text":"$(item)","color":"yellow"}]
$execute if data storage scdi:config {debug_custom_items:1b} if data entity @s SelectedItem{id:"$(item)"} run tellraw @s {"text":"[dbg]   id match: TRUE","color":"green"}
$execute if data storage scdi:config {debug_custom_items:1b} unless data entity @s SelectedItem{id:"$(item)"} run tellraw @s {"text":"[dbg]   id match: FALSE","color":"red"}
execute if data storage scdi:config {debug_custom_items:1b} if data storage scdi:tmp2 {enchant:""} run tellraw @s {"text":"[dbg]   enchant filter: blank (any)","color":"green"}
execute if data storage scdi:config {debug_custom_items:1b} unless data storage scdi:tmp2 {enchant:""} run tellraw @s {"text":"[dbg]   enchant filter: set","color":"yellow"}
execute if data storage scdi:config {debug_custom_items:1b} if predicate scdi:nulled_mainhand run tellraw @s {"text":"[dbg]   already nulled: TRUE (blocks nullify)","color":"red"}
execute if data storage scdi:config {debug_custom_items:1b} unless predicate scdi:nulled_mainhand run tellraw @s {"text":"[dbg]   already nulled: FALSE","color":"green"}
$execute if data entity @s SelectedItem{id:"$(item)"} if data storage scdi:tmp2 {enchant:""} unless predicate scdi:nulled_mainhand run function scdi:nullify_mainhand {orig:"$(item)"}
execute unless data storage scdi:tmp2 {enchant:""} run function scdi:check_custom_item_mainhand_enchant with storage scdi:tmp2
$execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s ["",{"text":"[dbg] checking offhand for ","color":"gray"},{"text":"$(item)","color":"yellow"}]
$execute if data storage scdi:config {debug_custom_items:1b} if data entity @s equipment.offhand{id:"$(item)"} run tellraw @s {"text":"[dbg]   offhand id match: TRUE","color":"green"}
$execute if data storage scdi:config {debug_custom_items:1b} unless data entity @s equipment.offhand{id:"$(item)"} run tellraw @s {"text":"[dbg]   offhand id match: FALSE","color":"red"}
execute if data storage scdi:config {debug_custom_items:1b} if predicate scdi:nulled_offhand run tellraw @s {"text":"[dbg]   offhand already nulled: TRUE (blocks nullify)","color":"red"}
execute if data storage scdi:config {debug_custom_items:1b} unless predicate scdi:nulled_offhand run tellraw @s {"text":"[dbg]   offhand already nulled: FALSE","color":"green"}
$execute if data entity @s equipment.offhand{id:"$(item)"} if data storage scdi:tmp2 {enchant:""} unless predicate scdi:nulled_offhand run function scdi:nullify_offhand {orig:"$(item)"}
execute unless data storage scdi:tmp2 {enchant:""} run function scdi:check_custom_item_offhand_enchant with storage scdi:tmp2

# also search equipment (armor) slots - offhand/armor live in their own
# "equipment" compound in this version, not the legacy Inventory[] list (see
# check_custom_item_equipment_slot.mcfunction), so these use a separate
# function family from the genuine inventory-slot scan below. slot_arg here
# is "armor.<key>" (the /item and /loot command's item_slot argument name),
# NOT "equipment.<key>" (that's the unrelated NBT data-path name used for
# the equip_key reads above/elsewhere) - same distinction that was wrong for
# the elytra path, see apply_nullify_armor.mcfunction.
$function scdi:check_custom_item_equipment_slot {equip_key:"head",slot_arg:"armor.head",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_equipment_slot {equip_key:"chest",slot_arg:"armor.chest",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_equipment_slot {equip_key:"legs",slot_arg:"armor.legs",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_equipment_slot {equip_key:"feet",slot_arg:"armor.feet",item:"$(item)",enchant:"$(enchant)"}

execute if data storage scdi:tmp2 {scan_inv:1b} run function scdi:check_custom_item_inventory with storage scdi:tmp2
