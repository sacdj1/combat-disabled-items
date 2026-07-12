# called as each scdi_dummy_damage_display entity, every tick, from
# tick.mcfunction. actively rises on its own (self-relative "~ ~0.05 ~"
# nudge every tick, not re-anchored to the dummy each tick like the other
# dummy displays - see apply_dummy_display_follow_tick2.mcfunction, which
# deliberately excludes this tag now) for a real RPG-style "pop up and
# float" look instead of just appearing and vanishing in place. kills it
# once it's existed for 20 ticks (1 real second) - a damage popup doesn't
# need to linger.
scoreboard players operation $dmg_display_age scdi_const = $ticks scdi_const
scoreboard players operation $dmg_display_age scdi_const -= @s scdi_display_spawn_tick
execute if score $dmg_display_age scdi_const matches 20.. run kill @s
execute if score $dmg_display_age scdi_const matches ..19 run teleport @s ~ ~0.05 ~
