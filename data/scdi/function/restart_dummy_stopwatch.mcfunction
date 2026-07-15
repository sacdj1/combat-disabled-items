# called with {id:N} - mirrors restart_stopwatch.mcfunction, restarts the
# dummy's own combat-lock stopwatch (real wall-clock time, not tick count -
# see apply_check_dummy_hit.mcfunction/dummy_combat_tick.mcfunction for why
# this replaced an earlier tick-based approximation that ran slow relative
# to real time under any server lag).
$stopwatch restart scdi:dummy_combat_$(id)
