# called with {delay:N,amount:N} as+at a dummy, from dummy_regen_tick.mcfunction.
# only heals once $ticks minus scdi_dummy_last_hit (set on every hit, see
# apply_check_dummy_hit.mcfunction, and at spawn) reaches delay - a dummy
# that's never been touched has scdi_dummy_last_hit still at its default 0,
# which trivially satisfies this immediately, but that's harmless since a
# never-hit dummy is already at full health with nothing to heal.
scoreboard players operation $dummy_regen_elapsed scdi_const = $ticks scdi_const
scoreboard players operation $dummy_regen_elapsed scdi_const -= @s scdi_dummy_last_hit
$execute if score $dummy_regen_elapsed scdi_const matches $(delay).. run function scdi:apply_dummy_regen_heal {amount:$(amount)}
