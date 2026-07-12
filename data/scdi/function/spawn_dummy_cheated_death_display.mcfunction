# called "at" a dummy right as it cheats death on a 20-point segment (see
# apply_dummy_invincible_segment_topoff.mcfunction) - same "execute ...
# summon ... run function ..." technique as the other dummy displays.
# passes the dummy's own scdi_dummy_id through so
# apply_dummy_display_follow_tick2.mcfunction can keep it glued to the
# dummy, same as the tag/one-shot displays.
execute store result storage scdi:tmp26 id int 1 run scoreboard players get @s scdi_dummy_id
execute at @s positioned ~ ~3.2 ~ summon minecraft:text_display run function scdi:apply_configure_dummy_cheated_death_display with storage scdi:tmp26
