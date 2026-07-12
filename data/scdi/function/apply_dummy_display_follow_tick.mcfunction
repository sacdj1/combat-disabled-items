# called as+at a dummy, from dummy_display_follow_tick.mcfunction. reads its
# own id and the configured teleport command as clean values first (same
# typed-literal-suffix stripping this pack always does before a macro
# substitution), then hands off to actually move each of its displays.
execute store result storage scdi:tmp16 id int 1 run scoreboard players get @s scdi_dummy_id
data modify storage scdi:tmp16 cmd set from storage scdi:config teleport_command
function scdi:apply_dummy_display_follow_tick2 with storage scdi:tmp16
