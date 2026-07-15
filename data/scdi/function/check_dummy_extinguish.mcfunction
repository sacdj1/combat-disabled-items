# called as+at @s = a dummy, from either dummy_combat_active.mcfunction
# (dummy_extinguish_in_combat) or apply_dummy_invincible_save.mcfunction
# (dummy_extinguish_on_cheat_death) -
# the caller already checked its own config gate before calling this, this
# just checks whether there's actually anything to do: on fire right now,
# and not already mid-sequence (prevents retriggering every tick the "in
# combat" caller keeps calling this while both conditions hold).
execute store result score $dummy_fire_ticks scdi_const run data get entity @s Fire 1
execute if score $dummy_fire_ticks scdi_const matches 1.. unless score @s scdi_dummy_extinguishing matches 1 run function scdi:apply_dummy_start_extinguish
