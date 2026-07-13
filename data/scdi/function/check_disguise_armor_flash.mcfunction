# called as @s = a currently-tagged player, every tick from
# combat_active.mcfunction. no longer gated on disguise_armor_model being
# leather - the flash lives entirely in particles now (see
# apply_disguise_armor_flash_check.mcfunction), an independent visual
# layer that doesn't care what the armor's own render model is. "at @s"
# here establishes position for the whole downstream chain - this is
# reached via "execute as @a[...] run function scdi:combat_tick" in
# tick.mcfunction, which sets the EXECUTOR to the player but never the
# POSITION, so without this the particle commands further down would
# spawn wherever the tick loop itself last ran, not at the player.
execute at @s if data storage scdi:config {disguise_armor_flash:1b} run function scdi:apply_disguise_armor_flash_check
