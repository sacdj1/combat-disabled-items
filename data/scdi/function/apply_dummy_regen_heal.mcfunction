# called with {amount:N} as+at a dummy whose regen delay has elapsed, from
# apply_dummy_regen_tick.mcfunction. adds amount to current health via
# plain scoreboard int math (Health is a float, but whole-number regen
# amounts are all this needs), then clamps before writing the result back -
# to the current segment ceiling (floor+20) for an invincible dummy, not
# the full pool, otherwise passive regen could quietly heal it past the
# segment its floor still thinks it's in, making the display
# (apply_compute_dummy_display_health.mcfunction: raw_health - floor) show
# more than 20/20. a mortal dummy still clamps to its real max_health as
# before.
execute store result score $dummy_regen_cur scdi_const run data get entity @s Health 1
execute store result score $dummy_regen_max scdi_const run attribute @s minecraft:max_health get 1
execute if score @s scdi_dummy_invincible matches 1.. run scoreboard players operation $dummy_regen_max scdi_const = @s scdi_dummy_invincible_floor
execute if score @s scdi_dummy_invincible matches 1.. run scoreboard players add $dummy_regen_max scdi_const 20
$scoreboard players add $dummy_regen_cur scdi_const $(amount)
execute if score $dummy_regen_cur scdi_const > $dummy_regen_max scdi_const run scoreboard players operation $dummy_regen_cur scdi_const = $dummy_regen_max scdi_const
execute store result entity @s Health float 1 run scoreboard players get $dummy_regen_cur scdi_const

# back at full health = this "encounter" is over - next hit starts a fresh
# DPS window instead of carrying on from damage dealt ages ago (see
# apply_check_dummy_hit.mcfunction).
execute if score $dummy_regen_cur scdi_const >= $dummy_regen_max scdi_const run scoreboard players set @s scdi_dummy_hit 0
