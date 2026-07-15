# called with {slot:"...",new_item:{...}} from apply_dummy_equip_item.mcfunction,
# a fresh function invocation so this macro substitution picks up the
# new_item value that was just written to storage this same tick.
$data modify entity @s equipment.$(slot) set value $(new_item)

# a plain /data write like the one above never makes a sound on its own -
# unlike a real player's or the disguised-armor path's equip_sound
# component (see apply_nullify_armor.mcfunction), this is a totally silent
# NBT write, so the sound has to be added explicitly.
playsound minecraft:item.armor.equip_generic player @a ~ ~ ~ 1.0 1.0
