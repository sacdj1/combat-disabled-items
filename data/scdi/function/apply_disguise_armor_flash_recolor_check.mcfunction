# called as+at @s = a tagged player, only when disguise_armor_recolor is
# on. reuses $armor_flash_new_phase, already computed moments earlier by
# the caller (apply_disguise_armor_flash_check.mcfunction) in this same
# tick - scdi_const is shared global scratch state (not per-entity), so
# it's still valid to read here without recomputing.
#
# unlike the particle spawn (cheap, every tick regardless), this only
# actually repaints the armor on a genuine phase CHANGE - $armor_flash_changed
# captures that BEFORE scdi_armor_flash_phase gets overwritten to the new
# value, since comparing the score against itself after overwriting it
# would always read as "unchanged". this at least minimizes how often the
# unavoidable equip sound fires, down to once per phase transition instead
# of every tick.
scoreboard players set $armor_flash_changed scdi_const 0
execute unless score @s scdi_armor_flash_phase = $armor_flash_new_phase scdi_const run scoreboard players set $armor_flash_changed scdi_const 1
scoreboard players operation @s scdi_armor_flash_phase = $armor_flash_new_phase scdi_const

# same disguise_armor_flash_color_a/_b config the particle flash uses (see
# load.mcfunction) - dyed_color wants the packed int directly, no
# unpacking needed here unlike the particle path.
execute if score $armor_flash_changed scdi_const matches 1 if score @s scdi_armor_flash_phase matches 1 store result storage scdi:tmp29 color int 1 run data get storage scdi:config disguise_armor_flash_color_b 1
execute if score $armor_flash_changed scdi_const matches 1 unless score @s scdi_armor_flash_phase matches 1 store result storage scdi:tmp29 color int 1 run data get storage scdi:config disguise_armor_flash_color_a 1
execute if score $armor_flash_changed scdi_const matches 1 run function scdi:apply_disguise_armor_flash_recolor with storage scdi:tmp29
