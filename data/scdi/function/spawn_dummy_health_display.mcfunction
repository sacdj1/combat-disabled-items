# called "at" a dummy right after it's summoned (see configure_new_dummy.mcfunction)
# - only if dummy_show_health is on (default: on, already checked by the
# caller). same "execute ... summon ... run function ..." technique used
# for the combat timer display: runs the configure step AS the new entity,
# no proximity guessing needed for the initial setup. positioned a bit
# lower than the player timer display (2.3 vs 2.6) since a mannequin's own
# height already puts its nametag closer to that point than a moving,
# crouch-capable player would. passes the dummy's own scdi_dummy_id through
# so the display can track it specifically (see
# apply_dummy_display_follow_tick2.mcfunction) instead of guessing by
# proximity - needed now that a dummy can actually move.
execute store result storage scdi:tmp13 id int 1 run scoreboard players get @s scdi_dummy_id
execute at @s positioned ~ ~2.3 ~ summon minecraft:text_display run function scdi:apply_configure_dummy_health_display with storage scdi:tmp13
