# called with {slot:"head"/"chest"/"legs"/"feet"} from
# apply_dummy_pickup_item.mcfunction, still as+at the dummy. clears any
# stale new_item/old_item left in scdi:tmp6 from a previous cycle first -
# without this, a slot that's empty THIS time (so old_item never gets
# rewritten below) could still read a leftover value from an earlier
# invocation and incorrectly drop a "ghost" item that isn't really there.
data remove storage scdi:tmp6 new_item
data remove storage scdi:tmp6 old_item

# captures the target item's full stack NBT and removes it FIRST, before
# touching the equipment slot at all - avoids a selector mixup where
# dropping the old piece back out (below) would otherwise leave a second
# item entity sitting right next to the original pickup target, and the
# "nearest item within 1.5 blocks" read could grab the wrong one. plain
# (non-macro) "set from" - copies data directly, no macro substitution
# needed for a read/copy like this.
execute if entity @e[type=item,distance=..1.5,sort=nearest,limit=1] run data modify storage scdi:tmp6 new_item set from entity @e[type=item,distance=..1.5,sort=nearest,limit=1] Item
kill @e[type=item,distance=..1.5,sort=nearest,limit=1]

# if the slot already has something equipped, capture it and drop it back
# onto the ground instead of just overwriting it - nothing should ever be
# silently destroyed just because a player dropped new armor near a dummy
# that already had a piece on. the actual drop needs a FRESH function call
# (apply_dummy_drop_old_equip.mcfunction), not a $(old_item) reference
# later in THIS function - macro substitution happens once, at call time,
# so a value written to storage mid-function is invisible to $() already
# "baked into" this same invocation; only a brand new "with storage" call
# picks up what was just written.
$execute if data entity @s equipment.$(slot) run data modify storage scdi:tmp6 old_item set from entity @s equipment.$(slot)
execute if data storage scdi:tmp6 old_item positioned ~ ~1 ~ run function scdi:apply_dummy_drop_old_equip with storage scdi:tmp6

# a 1-second pickup cooldown (same one apply_drop_all_dummy_items.mcfunction
# uses) so the dummy doesn't just immediately re-pick-up the old piece it
# was made to drop a moment ago, ping-ponging back and forth every tick
# instead of actually wearing the new item.
$execute if data entity @s equipment.$(slot) run scoreboard players operation @s scdi_dummy_pickup_cooldown_until = $ticks scdi_const
$execute if data entity @s equipment.$(slot) run scoreboard players add @s scdi_dummy_pickup_cooldown_until 20

# equips the captured new item - simplification: equips/consumes the
# ENTIRE item stack, not just one piece, if someone drops a stack of more
# than one - a test dummy doesn't need precise stack-splitting for this.
# same fresh-call requirement as the drop above (needs $(slot) AND
# $(new_item) together, and new_item was only just written this tick).
execute if data storage scdi:tmp6 new_item run function scdi:apply_dummy_finish_equip with storage scdi:tmp6
