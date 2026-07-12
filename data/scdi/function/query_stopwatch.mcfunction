# scale 1000: the stopwatch's actual base unit is elapsedSeconds (a double),
# not milliseconds - confirmed by disassembling StopwatchCommand.queryStopwatch,
# which computes (int)(elapsedSeconds * scale). scale=1 was silently returning
# truncated whole seconds (0,1,2...) instead of milliseconds, which is why the
# combat timer barely moved against a threshold calibrated for milliseconds.
$execute store result score @s scdi_elapsed run stopwatch query scdi:combat_$(id) 1000
