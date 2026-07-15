# called as+at whichever player just set ScdiPlayerMenuAction to a
# specific value via a My Settings button click (see player_menu_show.mcfunction/
# tick.mcfunction) - runs with the tick loop's own full permissions, same
# reasoning as dummy_menu_action_dispatch.mcfunction, though here it barely
# matters since these only ever touch the triggering player's own scores
# anyway (no allow_dummy_trigger-style gate to bypass).
execute if score @s ScdiPlayerMenuAction matches 1 run scoreboard players set @s scdi_armor_warning_pref 1
execute if score @s ScdiPlayerMenuAction matches 2 run scoreboard players set @s scdi_armor_warning_pref 0
execute if score @s ScdiPlayerMenuAction matches 3 run scoreboard players set @s scdi_inventory_warning_pref 1
execute if score @s ScdiPlayerMenuAction matches 4 run scoreboard players set @s scdi_inventory_warning_pref 0
execute if score @s ScdiPlayerMenuAction matches 5 run scoreboard players set @s scdi_armor_warning_sound_pref 1
execute if score @s ScdiPlayerMenuAction matches 6 run scoreboard players set @s scdi_armor_warning_sound_pref 0
execute if score @s ScdiPlayerMenuAction matches 7 run scoreboard players set @s scdi_inventory_warning_sound_pref 1
execute if score @s ScdiPlayerMenuAction matches 8 run scoreboard players set @s scdi_inventory_warning_sound_pref 0

# which sound plays for MY OWN armor/inventory warnings - a curated 3-way
# pick stored as the player's own custom entity NBT tag (same technique as
# the dummy's ScdiCheatDeathParticle, since this is a string and /trigger
# only ever carries an int, and a regular player can't run /data themselves -
# permission level 2). falls back to the OP-configured
# disguise_armor_warning_sound_id/disguise_inventory_warning_sound_id
# default if never set - see play_armor_warning_sound.mcfunction/
# play_inventory_warning_sound.mcfunction.
execute if score @s ScdiPlayerMenuAction matches 9 run data modify entity @s ScdiArmorWarningSoundId set value "minecraft:block.note_block.bit"
execute if score @s ScdiPlayerMenuAction matches 10 run data modify entity @s ScdiArmorWarningSoundId set value "minecraft:block.bell.use"
execute if score @s ScdiPlayerMenuAction matches 11 run data modify entity @s ScdiArmorWarningSoundId set value "minecraft:block.amethyst_block.chime"
execute if score @s ScdiPlayerMenuAction matches 15 run data modify entity @s ScdiArmorWarningSoundId set value "minecraft:block.note_block.pling"
execute if score @s ScdiPlayerMenuAction matches 16 run data modify entity @s ScdiArmorWarningSoundId set value "minecraft:entity.experience_orb.pickup"
execute if score @s ScdiPlayerMenuAction matches 12 run data modify entity @s ScdiInventoryWarningSoundId set value "minecraft:block.note_block.bit"
execute if score @s ScdiPlayerMenuAction matches 13 run data modify entity @s ScdiInventoryWarningSoundId set value "minecraft:block.bell.use"
execute if score @s ScdiPlayerMenuAction matches 14 run data modify entity @s ScdiInventoryWarningSoundId set value "minecraft:block.amethyst_block.chime"
execute if score @s ScdiPlayerMenuAction matches 17 run data modify entity @s ScdiInventoryWarningSoundId set value "minecraft:block.note_block.pling"
execute if score @s ScdiPlayerMenuAction matches 18 run data modify entity @s ScdiInventoryWarningSoundId set value "minecraft:entity.experience_orb.pickup"

# pitch/volume for MY OWN warning sounds - own separate pick per warning
# type (armor vs inventory), same entity-NBT-override-of-config-default
# pattern as the sound id pick above. falls back to combat_pitch/
# combat_volume if never set - see play_armor_warning_sound.mcfunction/
# play_inventory_warning_sound.mcfunction.
execute if score @s ScdiPlayerMenuAction matches 19 run data modify entity @s ScdiArmorWarningSoundPitch set value 0.5f
execute if score @s ScdiPlayerMenuAction matches 20 run data modify entity @s ScdiArmorWarningSoundPitch set value 1.0f
execute if score @s ScdiPlayerMenuAction matches 21 run data modify entity @s ScdiArmorWarningSoundPitch set value 1.5f
execute if score @s ScdiPlayerMenuAction matches 22 run data modify entity @s ScdiArmorWarningSoundVolume set value 0.5f
execute if score @s ScdiPlayerMenuAction matches 23 run data modify entity @s ScdiArmorWarningSoundVolume set value 1.0f
execute if score @s ScdiPlayerMenuAction matches 24 run data modify entity @s ScdiArmorWarningSoundVolume set value 2.0f
execute if score @s ScdiPlayerMenuAction matches 25 run data modify entity @s ScdiInventoryWarningSoundPitch set value 0.5f
execute if score @s ScdiPlayerMenuAction matches 26 run data modify entity @s ScdiInventoryWarningSoundPitch set value 1.0f
execute if score @s ScdiPlayerMenuAction matches 27 run data modify entity @s ScdiInventoryWarningSoundPitch set value 1.5f
execute if score @s ScdiPlayerMenuAction matches 28 run data modify entity @s ScdiInventoryWarningSoundVolume set value 0.5f
execute if score @s ScdiPlayerMenuAction matches 29 run data modify entity @s ScdiInventoryWarningSoundVolume set value 1.0f
execute if score @s ScdiPlayerMenuAction matches 30 run data modify entity @s ScdiInventoryWarningSoundVolume set value 2.0f
function scdi:player_menu_show
