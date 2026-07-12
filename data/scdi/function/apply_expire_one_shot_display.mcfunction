# called "as" each scdi_dummy_one_shot_display entity, every tick, from
# tick.mcfunction. kills it once it's existed for 60 ticks (3 real seconds) -
# a one-off announcement doesn't need to persist, unlike the combat timer
# display. $one_shot_age is scratch, safe to reuse scdi_const for since it's
# always recomputed fresh before use.
scoreboard players operation $one_shot_age scdi_const = $ticks scdi_const
scoreboard players operation $one_shot_age scdi_const -= @s scdi_display_spawn_tick
execute if score $one_shot_age scdi_const matches 60.. run kill @s
