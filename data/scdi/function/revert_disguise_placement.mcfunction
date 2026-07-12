data modify storage scdi:tmp item set from storage scdi:config disguise_item
# converted through "data get ... 1" to guarantee a clean, unsuffixed int -
# see check_proximity.mcfunction for why (fill's coordinates would otherwise
# silently reject a typed literal like "4.0d"/"4b" depending on how it was set)
execute store result storage scdi:tmp radius int 1 run data get storage scdi:config placement_revert_radius 1
function scdi:apply_revert_disguise_placement with storage scdi:tmp
