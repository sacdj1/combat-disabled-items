# called with {item:{...},slot:"...",dx:N,dz:N} still at the dummy's
# position (offset via "positioned ~ ~1 ~" by the caller) - summons the
# dropped item WITH its real captured stack (components, durability,
# enchantments, name and all) AND a toss velocity matching the dummy's own
# facing direction (dx/dz computed once in apply_drop_all_dummy_items.mcfunction),
# inline in one atomic command, instead of summoning an empty item entity
# and modifying it afterward. that two-step approach was a real bug: this
# game version's minecraft:item entities apparently get pruned as "empty"
# the instant they're added to the world (confirmed via the server log's
# "Tried to add entity minecraft:item but it was marked as removed already"
# warning, firing every single time), so by the time a follow-up
# "data modify" would've run, the entity was already gone. summoning with
# the real Item data already in place avoids the entity ever existing in an
# "empty" state.
$summon minecraft:item ~ ~ ~ {Item:$(item),Motion:[$(dx)d,0.25d,$(dz)d]}
