# called with {slot:"...",new_item:{...}} from apply_dummy_equip_item.mcfunction,
# a fresh function invocation so this macro substitution picks up the
# new_item value that was just written to storage this same tick.
$data modify entity @s equipment.$(slot) set value $(new_item)
