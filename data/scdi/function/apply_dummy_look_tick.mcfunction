# called with {range:N,cmd:"teleport"/"tp"} from dummy_look_tick.mcfunction.
# runs as every spawned dummy, checks for the nearest player within range
# from that dummy's OWN position, and if one exists, turns to face them -
# position unchanged, only rotation changes. it has NoAI so this is the only
# thing that ever moves/turns it.
#
# "anchored eyes" was the missing piece - without it, "facing entity ...
# eyes" computes the angle FROM the dummy's default anchor (its feet/base
# position) TO the target's eyes, which is why it kept tilting the head up
# too far at any reasonable distance. "anchored eyes" tells the execute
# chain to compute FROM the dummy's own eye position instead, matching how
# two players naturally look at each other (eye height to eye height, not
# feet to eyes).
$execute as @e[type=minecraft:mannequin,tag=scdi_dummy] at @s anchored eyes if entity @p[distance=..$(range)] facing entity @p[distance=..$(range)] eyes run $(cmd) @s ~ ~ ~ ~ ~
