# called with {id:N} from dummy_combat_tick.mcfunction - mirrors
# query_stopwatch.mcfunction exactly, including the scale=1000 gotcha
# (the stopwatch's real unit is elapsedSeconds, a double; scale 1000
# converts it to milliseconds - scale 1 silently truncates to whole
# seconds instead).
$execute store result score @s scdi_dummy_elapsed run stopwatch query scdi:dummy_combat_$(id) 1000
