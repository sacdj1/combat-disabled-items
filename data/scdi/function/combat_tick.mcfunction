# query how many real milliseconds have passed since @s's last hit
# (/stopwatch tracks wall-clock time, not game ticks)
execute store result storage scdi:tmp id int 1 run scoreboard players get @s scdi_id
function scdi:query_stopwatch with storage scdi:tmp

execute if score @s scdi_elapsed >= $duration scdi_const run function scdi:combat_end
execute unless score @s scdi_elapsed >= $duration scdi_const run function scdi:combat_active
