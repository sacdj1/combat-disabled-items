# called with {id:N} from configure_new_dummy.mcfunction, mirrors
# create_stopwatch.mcfunction but namespaced separately (dummy_combat_N,
# not combat_N) so dummy and player ids - two independent counters,
# scdi_dummy_id vs scdi_id - can never collide on the same stopwatch name.
$stopwatch create scdi:dummy_combat_$(id)
