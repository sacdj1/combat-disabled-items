# recurses from $uninstall_idx up to $next_id (the highest id ever handed
# out - see assign_stopwatch_id.mcfunction), best-effort removing each
# player's personal stopwatch. same recursion-over-a-counter technique used
# elsewhere in this pack (e.g. check_custom_item_recursive.mcfunction) since
# there's no real loop construct. must run BEFORE the scdi_const objective
# (which holds both $next_id and $uninstall_idx) gets removed in
# apply_uninstall.mcfunction.
execute unless score $uninstall_idx scdi_const <= $next_id scdi_const run return 0
execute store result storage scdi:tmp id int 1 run scoreboard players get $uninstall_idx scdi_const
function scdi:apply_uninstall_stopwatch_at_id with storage scdi:tmp
scoreboard players add $uninstall_idx scdi_const 1
function scdi:apply_uninstall_stopwatches
