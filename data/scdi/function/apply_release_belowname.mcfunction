# releases the below_name display slot back - called instead of a bare
# "scoreboard objectives setdisplay below_name" everywhere this pack gives
# up the slot (turned off, config reset, uninstalled). restores
# belowname_restore_objective if one was set (see load.mcfunction's
# show_timer_above_head/belowname_restore_objective comments), otherwise
# just clears the slot like before. must be called "with storage scdi:config".
execute if data storage scdi:config {belowname_restore_objective:""} run scoreboard objectives setdisplay below_name
$execute unless data storage scdi:config {belowname_restore_objective:""} run scoreboard objectives setdisplay below_name $(belowname_restore_objective)
