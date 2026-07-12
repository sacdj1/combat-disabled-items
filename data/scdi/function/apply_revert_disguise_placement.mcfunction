# clear out anything matching the disguise item's block form within
# placement_revert_radius of @s - undoes the placement instantly so it never
# really "sticks"
$execute at @s run fill ~-$(radius) ~-$(radius) ~-$(radius) ~$(radius) ~$(radius) ~$(radius) air replace $(item)
