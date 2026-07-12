# called "as" each scdi_dummy_cheated_death_display entity, every tick,
# from tick.mcfunction. same lifetime as the one-shot display (60 ticks/3
# real seconds) - a one-off announcement, not something meant to persist.
scoreboard players operation $cheated_death_display_age scdi_const = $ticks scdi_const
scoreboard players operation $cheated_death_display_age scdi_const -= @s scdi_display_spawn_tick
execute if score $cheated_death_display_age scdi_const matches 60.. run kill @s
