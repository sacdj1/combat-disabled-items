# called with {old_item:{...}} from apply_dummy_equip_item.mcfunction, a
# fresh function invocation so this macro substitution picks up the value
# that was just written to storage this same tick. summons the dropped
# item WITH its real data already inline in one atomic command - a
# summon-then-modify two-step doesn't work in this environment (the item
# entity gets pruned as empty before a follow-up modify can run - see
# apply_finish_drop_dummy_armor.mcfunction for the same fix applied there).
$summon minecraft:item ~ ~ ~ {Item:$(old_item)}
