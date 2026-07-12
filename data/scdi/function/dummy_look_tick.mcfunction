# entry point, called once per tick from tick.mcfunction only if
# dummy_look_at_player is enabled. dummy_look_range is stored as a double
# (e.g. 10.0d) for easy editing, but macro-substituting it directly into a
# selector's distance= argument would insert the raw "10.0d" text (NBT's
# typed-literal suffix) - not valid selector syntax - same gotcha already
# solved for proximity_distance in check_proximity.mcfunction; "data get ...
# 1" strips the suffix by producing a clean int instead.
execute store result storage scdi:tmp4 range int 1 run data get storage scdi:config dummy_look_range 1
data modify storage scdi:tmp4 cmd set from storage scdi:config teleport_command
function scdi:apply_dummy_look_tick with storage scdi:tmp4
