# entry point, called every $dummy_regen_interval ticks from tick.mcfunction,
# only if dummy_regen is enabled (default: on). reads delay/amount as clean
# numbers first (same typed-literal-suffix stripping this pack always does
# before a macro substitution - see check_proximity.mcfunction) then hands
# off once per currently-spawned dummy.
execute store result storage scdi:tmp8 delay int 1 run data get storage scdi:config dummy_regen_delay 1
execute store result storage scdi:tmp8 amount int 1 run data get storage scdi:config dummy_regen_amount 1
execute as @e[type=minecraft:mannequin,tag=scdi_dummy] at @s run function scdi:apply_dummy_regen_tick with storage scdi:tmp8
