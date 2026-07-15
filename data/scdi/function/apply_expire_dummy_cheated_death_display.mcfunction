# called "as" each scdi_dummy_cheated_death_display entity, every tick,
# from tick.mcfunction. shortened from an original 60 ticks (3 real
# seconds, matching the one-shot display) down to 25 (1.25s) - this one
# fires MUCH more often now that cheating death is the always-heal-to-full
# backstop for every 20+ damage hit rather than a rare event, so lingering
# as long as the one-off one-shot announcement got noticeably in the way.
scoreboard players operation $cheated_death_display_age scdi_const = $ticks scdi_const
scoreboard players operation $cheated_death_display_age scdi_const -= @s scdi_display_spawn_tick
execute if score $cheated_death_display_age scdi_const matches 25.. run kill @s
