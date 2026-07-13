# called with {equip_key,slot_arg,color} - only proceed if that slot
# currently holds a disguised (nulled) item, same predicate
# check_restore_equipment_slot.mcfunction uses. unlike particles, this
# genuinely writes to the armor's own data - item modify set_components,
# confirmed working directly on a player's already-equipped slot with no
# armor-stand relay needed (this only mutates an EXISTING item's
# components, not its type - see
# debug/diagnose_item_modify_components.mcfunction). WILL play a sound
# every time (disguise_armor_equip_sound, set on the item at nullify time,
# picks which one - see apply_nullify_armor.mcfunction) - that's the
# accepted tradeoff of turning disguise_armor_recolor on at all.
$execute if data entity @s equipment.$(equip_key){components:{"minecraft:custom_data":{scdi:{null:1b}}}} run item modify entity @s $(slot_arg) {"function":"minecraft:set_components","components":{"minecraft:dyed_color":$(color)}}
