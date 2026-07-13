# called once per tick as each PINNED dummy (see tick.mcfunction). teleports
# it back to its exact captured position, unconditionally - this is what
# makes it immune to pistons, water/lava currents, or any other physical
# displacement, not just combat knockback (dummy_immobile only sets
# knockback_resistance, which does nothing against those). scdi_dummy_pin_x/
# y/z are captured at *1000 scale (see menu/dummy_menu_pin_on.mcfunction) -
# divide back down to a real decimal via storage before teleporting.
#
# hands off to a SEPARATE function (with storage) for the actual macro
# teleport, rather than a macro line later in this SAME file - writing to
# storage then referencing it via $() in the same invocation doesn't work,
# macro substitution happens once, at the moment a function is *invoked*,
# not when the storage is written (see CONTRIBUTING.md).
execute store result storage scdi:tmp27 x double 0.001 run scoreboard players get @s scdi_dummy_pin_x
execute store result storage scdi:tmp27 y double 0.001 run scoreboard players get @s scdi_dummy_pin_y
execute store result storage scdi:tmp27 z double 0.001 run scoreboard players get @s scdi_dummy_pin_z
function scdi:apply_dummy_pin_tick2 with storage scdi:tmp27
