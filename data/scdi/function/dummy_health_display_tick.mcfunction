# entry point, called once per tick from tick.mcfunction only if
# dummy_show_health is enabled. runs as every spawned dummy.
execute as @e[type=minecraft:mannequin,tag=scdi_dummy] at @s run function scdi:apply_update_dummy_health_display
