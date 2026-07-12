# entry point, called once per tick from tick.mcfunction only if
# dummy_pickup_items is enabled. runs as every spawned dummy; for each one
# with any item within 1.5 blocks, hands off to apply_dummy_pickup_item.mcfunction
# to actually determine whether it's armor (and which slot) - not gated on
# minecraft:equippable here, since that component is essentially never
# present on a plain vanilla armor piece's stored NBT (see
# apply_dummy_pickup_item.mcfunction for why). the dummy has NoAI, so this
# is entirely our own command-driven "pickup", not vanilla mob pickup AI.
#
# "unless scdi_dummy_pickup_cooldown_until > $ticks" skips a dummy that just
# dropped its own items a moment ago (see
# apply_drop_all_dummy_items.mcfunction) - otherwise it would just
# immediately re-equip the very items it was made to throw away. an unset
# cooldown (never dropped anything) makes the ">" comparison fail, which
# "unless" treats as satisfied, so a fresh dummy is never blocked by this.
execute as @e[type=minecraft:mannequin,tag=scdi_dummy] at @s unless score @s scdi_dummy_pickup_cooldown_until > $ticks scdi_const if entity @e[type=item,distance=..1.5] run function scdi:apply_dummy_pickup_item
