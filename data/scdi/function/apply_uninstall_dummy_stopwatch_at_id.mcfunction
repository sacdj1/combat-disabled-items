# called with {id:N} from apply_uninstall_dummy_stopwatches.mcfunction -
# mirrors apply_uninstall_stopwatch_at_id.mcfunction, same best-effort
# reasoning (unconfirmed whether this game version's /stopwatch even has a
# "remove" subcommand - harmless either way, see that file).
$stopwatch remove scdi:dummy_combat_$(id)
