# only matters while @s is actually locked out - a disguised item is the only
# way they'd have the configured disguise_item in hand at all
execute if score @s scdi_tag matches 1 run function scdi:revert_disguise_placement

# reset the advancement so it can fire again on the next block placed
advancement revoke @s only scdi:placed_block
