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
scoreboard players operation $dps_elapsed scdi_const = $ticks scdi_const
scoreboard players operation $dps_elapsed scdi_const -= @s scdi_dummy_encounter_start_tick
execute if score $dps_elapsed scdi_const matches ..0 run scoreboard players set $dps_elapsed scdi_const 1
scoreboard players operation $dps_num scdi_const = @s scdi_dummy_total_dmg
scoreboard players operation $dps_num scdi_const *= $two scdi_const
scoreboard players operation $dps_num scdi_const /= $dps_elapsed scdi_const
execute store result storage scdi:tmp9 dps int 1 run scoreboard players get $dps_num scdi_const

function scdi:apply_update_dummy_health_display_text with storage scdi:tmp9
