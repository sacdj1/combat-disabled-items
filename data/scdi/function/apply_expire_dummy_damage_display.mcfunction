# called as+at each scdi_dummy_damage_display entity, every tick, from
# tick.mcfunction. actively rises on its own (self-relative "~ ~0.05 ~"
# nudge every tick, not re-anchored to the dummy each tick like the other
# dummy displays - see apply_dummy_display_follow_tick2.mcfunction, which
# deliberately excludes this tag now) for a real RPG-style "pop up and
# float" look instead of just appearing and vanishing in place. kills it
# once it's existed for 20 ticks (1 real second) - a damage popup doesn't
# need to linger.
#
# the caller MUST include "at @s", not just "as @s" - the "~ ~0.05 ~"
# below is relative to the CURRENT execute position context, which without
# "at" stays whatever tick.mcfunction's own root context is (effectively
# world origin), not this display's actual position. missing that "at" was
# the root cause of damage numbers appearing to spawn at/snap toward world
# origin instead of floating up from above the dummy - the FIRST teleport
# after spawning would yank it from its correct spawn point straight
# toward (0,0,0)-ish territory, and everything after just drifted from
# there.
scoreboard players operation $dmg_display_age scdi_const = $ticks scdi_const
scoreboard players operation $dmg_display_age scdi_const -= @s scdi_display_spawn_tick
execute if score $dmg_display_age scdi_const matches 20.. run kill @s
execute if score $dmg_display_age scdi_const matches ..19 run teleport @s ~ ~0.05 ~
