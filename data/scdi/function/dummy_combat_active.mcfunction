# called as+at @s = a dummy still within its own combat-lock window.
# reuses the exact same nullify/flash logic a real tagged player goes
# through - both already operate generically on @s via equipment.<slot>
# NBT paths (not anything player-specific), with one known gap: mainhand-
# specific paths (nullify_mainhand's SelectedItem, used for firework
# rocket/wind charge disabling) only exist on real players, so those two
# silently never match on a dummy. everything else - elytra (equipment.chest),
# offhand, and all 4 custom-item armor slots - works the same as it would
# for a real player, since those already read/write via equipment.<slot>.
# throttled to $nullify_interval ticks, same as the real-player path in
# combat_active.mcfunction.
execute if score $nullify_mod scdi_const matches 0 run function scdi:nullify_check
function scdi:check_disguise_armor_flash

# self-extinguish while in combat (per-dummy toggle, off by default for
# newly spawned dummies - see load.mcfunction's dummy_extinguish_in_combat
# comment)
execute if score @s scdi_dummy_extinguish_in_combat matches 1.. run function scdi:check_dummy_extinguish
