# recurses from $uninstall_idx up to $next_dummy_id, best-effort removing
# each dummy's own combat-lock stopwatch (create_dummy_stopwatch.mcfunction) -
# mirrors apply_uninstall_stopwatches.mcfunction exactly, just over the
# dummy id counter instead of the player one. reuses $uninstall_idx (reset
# again by the caller before this runs) since the player loop already
# finished by the time this one starts, not running concurrently with it.
execute unless score $uninstall_idx scdi_const <= $next_dummy_id scdi_const run return 0
execute store result storage scdi:tmp10 id int 1 run scoreboard players get $uninstall_idx scdi_const
function scdi:apply_uninstall_dummy_stopwatch_at_id with storage scdi:tmp10
scoreboard players add $uninstall_idx scdi_const 1
function scdi:apply_uninstall_dummy_stopwatches
