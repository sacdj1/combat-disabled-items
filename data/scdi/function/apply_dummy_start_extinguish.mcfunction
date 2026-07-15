# called as+at @s = a dummy that's on fire and not already mid-sequence -
# see check_dummy_extinguish.mcfunction. stops looking at the player
# (apply_dummy_look_tick.mcfunction excludes a busy dummy via
# scdi_dummy_extinguishing), looks straight down, places a water block at
# its feet if free, else its head, extinguishes it immediately, and
# leaves the water/bucket in place for just a few ticks before
# apply_dummy_finish_extinguish.mcfunction cleans up - long enough to read
# as "it placed water", short enough that the source block never gets a
# chance to start flowing/spreading into neighboring air blocks.
#
# known limitation: this overwrites whatever was already in the dummy's
# mainhand with the water bucket, and clears it to empty afterward rather
# than restoring what was there before - fine for the common case (dummies
# don't usually need to hold a mainhand item for testing), but a
# pre-equipped mainhand item would be lost. worth a snapshot/restore if
# that turns out to matter in practice.
scoreboard players set @s scdi_dummy_extinguishing 1
item replace entity @s weapon.mainhand with minecraft:water_bucket
teleport @s ~ ~ ~ ~ 90

# -1 = already wet (feet or head already water) or neither spot is
# actually placeable (not air, not water) - skip placing anything rather
# than stacking water on water or on a solid block. checked in priority
# order: already-water beats everything (nothing to do), then feet-is-air,
# then head-is-air, then give up.
execute if block ~ ~ ~ minecraft:water run scoreboard players set @s scdi_dummy_extinguish_y_offset -1
execute unless block ~ ~ ~ minecraft:water if block ~ ~1 ~ minecraft:water run scoreboard players set @s scdi_dummy_extinguish_y_offset -1
execute unless block ~ ~ ~ minecraft:water unless block ~ ~1 ~ minecraft:water if block ~ ~ ~ air run scoreboard players set @s scdi_dummy_extinguish_y_offset 0
execute unless block ~ ~ ~ minecraft:water unless block ~ ~1 ~ minecraft:water unless block ~ ~ ~ air if block ~ ~1 ~ air run scoreboard players set @s scdi_dummy_extinguish_y_offset 1
execute unless block ~ ~ ~ minecraft:water unless block ~ ~1 ~ minecraft:water unless block ~ ~ ~ air unless block ~ ~1 ~ air run scoreboard players set @s scdi_dummy_extinguish_y_offset -1

execute if score @s scdi_dummy_extinguish_y_offset matches 0 run setblock ~ ~ ~ minecraft:water
execute if score @s scdi_dummy_extinguish_y_offset matches 1 run setblock ~ ~1 ~ minecraft:water

data modify entity @s Fire set value 0s

scoreboard players operation @s scdi_dummy_extinguish_until = $ticks scdi_const
scoreboard players add @s scdi_dummy_extinguish_until 3
