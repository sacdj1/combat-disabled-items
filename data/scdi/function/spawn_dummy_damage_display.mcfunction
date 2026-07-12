# called as+at a dummy that just took damage ($dummy_dmg_whole/$dummy_dmg_tenths
# already computed in apply_check_dummy_hit.mcfunction), only if
# dummy_damage_numbers is on (default: on). RPG-style floating "-N.n"
# popup, same "execute ... summon ... run function ... with storage ..."
# technique as the other dummy displays. no owner-id needed - unlike the
# other dummy displays, this one doesn't track the dummy's position after
# spawning, it just floats up on its own (see
# apply_expire_dummy_damage_display.mcfunction).
execute store result storage scdi:tmp23 whole int 1 run scoreboard players get $dummy_dmg_whole scdi_const
execute store result storage scdi:tmp23 tenths int 1 run scoreboard players get $dummy_dmg_tenths scdi_const
execute at @s positioned ~ ~2.6 ~ summon minecraft:text_display run function scdi:apply_configure_dummy_damage_display with storage scdi:tmp23
