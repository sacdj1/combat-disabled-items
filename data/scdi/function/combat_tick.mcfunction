# query how many real milliseconds have passed since @s's last hit
# (/stopwatch tracks wall-clock time, not game ticks) - throttled to
# $combat_tick_interval ticks (default 1 = every tick, see load.mcfunction
# for the tradeoff of raising it). combat_active/combat_end below still run
# every tick regardless, just against whatever scdi_elapsed value was last
# queried.
execute if score $combat_tick_mod scdi_const matches 0 store result storage scdi:tmp id int 1 run scoreboard players get @s scdi_id
execute if score $combat_tick_mod scdi_const matches 0 run function scdi:query_stopwatch with storage scdi:tmp

execute if score @s scdi_elapsed >= $duration scdi_const run function scdi:combat_end
execute unless score @s scdi_elapsed >= $duration scdi_const run function scdi:combat_active
