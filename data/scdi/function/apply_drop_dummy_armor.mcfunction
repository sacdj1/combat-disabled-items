# called at @s = the dummy, once its hit is confirmed lethal (see
# apply_check_dummy_hit2.mcfunction). drops each equipped armor slot as a
# real item entity, then removes the dummy - reuses
# apply_drop_all_dummy_items.mcfunction (also used by the manual [Drop all
# items] button and [Remove]/[Remove all]) for the actual drop, then kills
# the dummy on top of that, since a plain minecraft:mannequin has no loot
# table of its own and would otherwise just silently discard whatever it
# had on.
function scdi:apply_drop_all_dummy_items
kill @s
