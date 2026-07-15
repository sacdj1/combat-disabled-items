# entry point, called every $dummy_regen_interval ticks from tick.mcfunction.
# per-dummy toggle now (scdi_dummy_regen, seeded from dummy_regen at spawn -
# see configure_new_dummy.mcfunction/dummy_menu2_show.mcfunction), not a
# single global on/off - only dummies with it enabled are selected below.
# delay/amount stay global tuning values shared by every regenerating
# dummy, read as clean numbers first (same typed-literal-suffix stripping
# this pack always does before a macro substitution - see
# check_proximity.mcfunction) then handed off once per matching dummy.
execute store result storage scdi:tmp8 delay int 1 run data get storage scdi:config dummy_regen_delay 1
execute store result storage scdi:tmp8 amount int 1 run data get storage scdi:config dummy_regen_amount 1
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,scores={scdi_dummy_regen=1..}] at @s run function scdi:apply_dummy_regen_tick with storage scdi:tmp8
