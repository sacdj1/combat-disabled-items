# releases the tab list ("list") display slot back - same pattern as
# apply_release_belowname.mcfunction, see there for why a restore-objective
# config is needed at all (vanilla has no command to query what's
# currently on a display slot). restores tablist_restore_objective if one
# was set, otherwise just clears the slot. must be called "with storage
# scdi:config".
execute if data storage scdi:config {tablist_restore_objective:""} run scoreboard objectives setdisplay list
$execute unless data storage scdi:config {tablist_restore_objective:""} run scoreboard objectives setdisplay list $(tablist_restore_objective)
