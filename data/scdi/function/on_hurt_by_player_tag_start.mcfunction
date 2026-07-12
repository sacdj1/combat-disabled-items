# runs only the very moment a player transitions from untagged to tagged -
# see on_hurt_by_player.mcfunction. the timer always starts fresh here,
# regardless of the retag_resets_timer setting (that only affects hits taken
# while already tagged). id assignment now runs FIRST, before
# on_hurt_by_player_first - that function spawns the floating timer display,
# which needs @s's scdi_id already assigned to tag the display with the
# right owner (see spawn_timer_display.mcfunction).
execute unless score @s scdi_id matches 1.. run function scdi:assign_stopwatch_id
function scdi:on_hurt_by_player_first
function scdi:restart_stopwatch
