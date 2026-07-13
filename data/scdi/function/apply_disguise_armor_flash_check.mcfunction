# called as+at @s = a tagged player, once check_disguise_armor_flash.mcfunction
# confirms disguise_armor_flash is on. computed from the GLOBAL tick
# counter (not anything per-player) so every disguised piece on every
# tagged player flashes in sync. no per-player "did the phase change"
# tracking needed anymore (unlike the old NBT-rewriting version) - spawning
# a particle every tick doesn't touch any entity's data, so there's no
# equip-sound risk to gate behind a change check, and particles are cheap
# enough to just emit continuously.
#
# 4-step cycle (not a plain 50/50 toggle) - red, yellow, red, red, so red
# shows 3x as often as yellow instead of an even split.
execute store result score $armor_flash_interval scdi_const run data get storage scdi:config disguise_armor_flash_interval 1
scoreboard players operation $armor_flash_phase scdi_const = $ticks scdi_const
scoreboard players operation $armor_flash_phase scdi_const /= $armor_flash_interval scdi_const
scoreboard players operation $armor_flash_phase scdi_const %= $four scdi_const

execute if score $armor_flash_phase scdi_const matches 1 run function scdi:apply_disguise_armor_flash_particles {r:1.0d,g:1.0d,b:0.0d}
execute unless score $armor_flash_phase scdi_const matches 1 run function scdi:apply_disguise_armor_flash_particles {r:1.0d,g:0.0d,b:0.0d}
