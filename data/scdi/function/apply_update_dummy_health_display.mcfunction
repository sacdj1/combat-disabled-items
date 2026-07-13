# called as+at a dummy (from dummy_health_display_tick.mcfunction) - reads
# current health, max health (via the shared display-health helper - real
# values for a mortal dummy, a normal-player-sized 0-20 value for an
# invincible one), its own tracking id, and computes a live DPS reading
# (total damage this encounter / seconds elapsed since it started - see
# apply_check_dummy_hit.mcfunction for how the encounter window resets),
# then hands off to the text-update step.
function scdi:apply_compute_dummy_display_health
execute store result storage scdi:tmp9 id int 1 run scoreboard players get @s scdi_dummy_id

# scdi_dummy_total_dmg is in TENTHS of a health point (scale 10 - see
# apply_check_dummy_hit.mcfunction), and elapsed is in ticks (20/sec), so
# converting to real HP/sec needs *20 (ticks -> seconds) /10 (undo the
# tenths scale) = *2, not *20 - using $twenty here was a real bug that made
# every DPS reading exactly 10x too high.
#
# elapsed is floored to dummy_dps_window ticks (default 20 = 1 second, see
# load.mcfunction/menu -> Misc), not just clamped above 0 -
# scdi_dummy_encounter_start_tick gets set to THIS SAME tick on a fresh
# encounter's first hit (see apply_check_dummy_hit.mcfunction), so without
# this floor, that first hit's damage was being divided by as little as 1
# tick and extrapolated into a wildly inflated instantaneous rate (a single
# 1.5-damage hit reading as "30 DPS") instead of a real sustained average -
# technically correct math, but meaningless and confusing this early in an
# encounter, since the dummy obviously isn't dying at that rate. read fresh
# from storage every tick (not a fixed scratch constant) so changing the
# setting takes effect immediately, no reload needed.
execute store result score $dps_window scdi_const run data get storage scdi:config dummy_dps_window 1
scoreboard players operation $dps_elapsed scdi_const = $ticks scdi_const
scoreboard players operation $dps_elapsed scdi_const -= @s scdi_dummy_encounter_start_tick
execute if score $dps_elapsed scdi_const < $dps_window scdi_const run scoreboard players operation $dps_elapsed scdi_const = $dps_window scdi_const
scoreboard players operation $dps_num scdi_const = @s scdi_dummy_total_dmg
scoreboard players operation $dps_num scdi_const *= $two scdi_const
scoreboard players operation $dps_num scdi_const /= $dps_elapsed scdi_const
execute store result storage scdi:tmp9 dps int 1 run scoreboard players get $dps_num scdi_const

function scdi:apply_update_dummy_health_display_text with storage scdi:tmp9
