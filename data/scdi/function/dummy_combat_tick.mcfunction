# called as+at @s = a dummy currently in its own combat-lock
# (scdi_dummy_tag=1, see apply_check_dummy_hit.mcfunction/
# dummy_combat_simulation), every tick from tick.mcfunction. queries the
# dummy's own real-time /stopwatch (create_dummy_stopwatch.mcfunction,
# restarted every hit) - same mechanism and same units (real milliseconds)
# a real player's own combat lock uses, so $duration compares apples to
# apples. an earlier version approximated elapsed time from the tick
# counter instead ($ticks * 50ms), which quietly ran slow relative to real
# time under any server lag, making a dummy's combat lock outlast a real
# player's equivalent duration.
# throttled to $combat_tick_interval ticks, same as combat_tick.mcfunction's
# real-player equivalent.
execute if score $combat_tick_mod scdi_const matches 0 store result storage scdi:tmp10 id int 1 run scoreboard players get @s scdi_dummy_id
execute if score $combat_tick_mod scdi_const matches 0 run function scdi:query_dummy_stopwatch with storage scdi:tmp10

# debugging aid (debug_hit_messages, default off - see /menu -> Detection) -
# noisy (every tick a dummy is tagged), only turn on briefly to check
# whether elapsed is actually counting up and crossing $duration.
execute if data storage scdi:config {debug_hit_messages:1b} run tellraw @a [{"text":"[dummy-tag-dbg] id=","color":"gray"},{"score":{"name":"@s","objective":"scdi_dummy_id"}},{"text":" elapsed=","color":"gray"},{"score":{"name":"@s","objective":"scdi_dummy_elapsed"}},{"text":" duration=","color":"gray"},{"score":{"name":"$duration","objective":"scdi_const"}}]

execute if score @s scdi_dummy_elapsed >= $duration scdi_const run function scdi:dummy_combat_end
execute unless score @s scdi_dummy_elapsed >= $duration scdi_const run function scdi:dummy_combat_active
