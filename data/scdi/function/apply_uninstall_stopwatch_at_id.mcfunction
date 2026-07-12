# called with {id:N} from apply_uninstall_stopwatches.mcfunction. best-effort
# only - "remove" isn't a subcommand this pack has ever actually confirmed
# exists for /stopwatch (only create/query/restart are verified, see
# create_stopwatch.mcfunction/query_stopwatch.mcfunction/restart_stopwatch.mcfunction
# and the README's /stopwatch section). if this game version's /stopwatch has
# no "remove", this line just errors harmlessly - stopwatches aren't visible
# anywhere in-game (no scoreboard/sidebar entry, nothing lists them), so a
# leftover one is inert clutter at worst, not a visible problem.
$stopwatch remove scdi:combat_$(id)
