# called as+at @s = a tagged player, once check_disguise_armor_flash.mcfunction
# confirms disguise_armor_flash is on. computed from the GLOBAL tick
# counter (not anything per-player) so every disguised piece on every
# tagged player flashes in sync. particles spawn every tick regardless (no
# entity data touched, so no equip-sound risk, cheap enough to just emit
# continuously) - the optional armor recolor below is different, and gates
# itself behind an actual phase-change check in
# apply_disguise_armor_flash_recolor_check.mcfunction.
#
# 4-step cycle (not a plain 50/50 toggle) - red, yellow, red, red, so red
# shows 3x as often as yellow instead of an even split.
execute store result score $armor_flash_interval scdi_const run data get storage scdi:config disguise_armor_flash_interval 1
scoreboard players operation $armor_flash_new_phase scdi_const = $ticks scdi_const
scoreboard players operation $armor_flash_new_phase scdi_const /= $armor_flash_interval scdi_const
scoreboard players operation $armor_flash_new_phase scdi_const %= $four scdi_const

execute if score $armor_flash_new_phase scdi_const matches 1 run function scdi:apply_disguise_armor_flash_particles {r:1.0d,g:1.0d,b:0.0d}
execute unless score $armor_flash_new_phase scdi_const matches 1 run function scdi:apply_disguise_armor_flash_particles {r:1.0d,g:0.0d,b:0.0d}

# optional armor recolor (disguise_armor_recolor, off by default - see
# load.mcfunction) - the armor ITSELF also repaints, not just particles.
# will make a sound every time (disguise_armor_equip_sound picks which
# one) - accepted tradeoff for anyone who wants it, not the default.
execute if data storage scdi:config {disguise_armor_recolor:1b} run function scdi:apply_disguise_armor_flash_recolor_check
