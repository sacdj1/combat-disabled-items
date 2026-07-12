# called as+at a dummy - writes {hp,max} into scdi:tmp9, shared by the
# floating health display (apply_update_dummy_health_display.mcfunction)
# and the /trigger ScdiDummyMenu chat readout (dummy_menu_show.mcfunction),
# so both always show the same thing.
#
# neither branch shows the real raw pool number (e.g. "980/1000") - both
# scale down to a 0-20 "looks like a normal player's health bar" readout,
# just using different math since the two death conditions work
# differently. reads Health fresh from entity NBT (not the scdi_health
# score, which is only refreshed on an actual hit - passive regen between
# hits changes raw Health without touching that cached score, which would
# otherwise desync the display from reality).
execute store result storage scdi:tmp9 hp int 1 run data get entity @s Health 1
execute store result storage scdi:tmp9 max int 1 run attribute @s minecraft:max_health get 1

# invincible: shows the value relative to scdi_dummy_invincible_floor -
# looks and behaves exactly like a normal player's health bar, refilling
# to 20 every time apply_dummy_invincible_segment_topoff.mcfunction fires.
execute if score @s scdi_dummy_invincible matches 1.. store result score $dummy_display_hp scdi_const run data get entity @s Health 1
execute if score @s scdi_dummy_invincible matches 1.. run scoreboard players operation $dummy_display_hp scdi_const -= @s scdi_dummy_invincible_floor
# defensive clamp to 0-20 - healing (menu "Heal to full", passive regen)
# should already keep raw Health and the floor in sync so this never
# triggers in practice, but if anything else ever heals a dummy without
# going through those two, this stops the display from ever showing an
# impossible value like "40/20" instead of silently trusting the math.
execute if score @s scdi_dummy_invincible matches 1.. if score $dummy_display_hp scdi_const matches 21.. run scoreboard players set $dummy_display_hp scdi_const 20
execute if score @s scdi_dummy_invincible matches 1.. if score $dummy_display_hp scdi_const matches ..-1 run scoreboard players set $dummy_display_hp scdi_const 0
execute if score @s scdi_dummy_invincible matches 1.. store result storage scdi:tmp9 hp int 1 run scoreboard players get $dummy_display_hp scdi_const
execute if score @s scdi_dummy_invincible matches 1.. run data modify storage scdi:tmp9 max set value 20

# mortal: a straight proportional scale of the whole pool onto 0-20
# (raw_health * 20 / max_health) instead - a floor-relative approach like
# invincible's doesn't fit here, since a mortal dummy has one single
# bottom-anchored death threshold (dummy_death_threshold, default 20 raw)
# rather than a repeating top-down segment, so it needs to read
# meaningfully across the ENTIRE health range, not just the last stretch.
execute unless score @s scdi_dummy_invincible matches 1.. store result score $dummy_display_hp scdi_const run data get entity @s Health 1
execute unless score @s scdi_dummy_invincible matches 1.. store result score $dummy_display_max scdi_const run attribute @s minecraft:max_health get 1
execute unless score @s scdi_dummy_invincible matches 1.. run scoreboard players operation $dummy_display_hp scdi_const *= $twenty scdi_const
execute unless score @s scdi_dummy_invincible matches 1.. run scoreboard players operation $dummy_display_hp scdi_const /= $dummy_display_max scdi_const
execute unless score @s scdi_dummy_invincible matches 1.. store result storage scdi:tmp9 hp int 1 run scoreboard players get $dummy_display_hp scdi_const
execute unless score @s scdi_dummy_invincible matches 1.. run data modify storage scdi:tmp9 max set value 20
