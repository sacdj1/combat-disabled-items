# entry point, called every tick from tick.mcfunction unconditionally (not
# gated on any single display setting - there's normally 0-few dummies, and
# a dummy might have a health display, a one-shot display, and a tag
# display all active/expiring at once, so gating this on just one of those
# settings would leave the others stranded). runs once per dummy.
execute as @e[type=minecraft:mannequin,tag=scdi_dummy] at @s run function scdi:apply_dummy_display_follow_tick
