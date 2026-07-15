# same idea as play_armor_warning_sound.mcfunction, for
# check_inventory_warning.mcfunction - own dedicated
# disguise_inventory_warning_sound_id, still only ever played to the one
# warned player. the player's own ScdiInventoryWarningSoundId choice
# overrides the OP-configured default if they've ever picked one.
# pitch/volume likewise fall back to combat_pitch/combat_volume, overridden
# by the player's own ScdiInventoryWarningSoundPitch/ScdiInventoryWarningSoundVolume
# if set (own pick, separate from the armor warning's).
data modify storage scdi:tmp sound set from storage scdi:config disguise_inventory_warning_sound_id
execute if data entity @s ScdiInventoryWarningSoundId run data modify storage scdi:tmp sound set from entity @s ScdiInventoryWarningSoundId
data modify storage scdi:tmp pitch set from storage scdi:config combat_pitch
execute if data entity @s ScdiInventoryWarningSoundPitch run data modify storage scdi:tmp pitch set from entity @s ScdiInventoryWarningSoundPitch
data modify storage scdi:tmp volume set from storage scdi:config combat_volume
execute if data entity @s ScdiInventoryWarningSoundVolume run data modify storage scdi:tmp volume set from entity @s ScdiInventoryWarningSoundVolume
function scdi:apply_play_combat_sound with storage scdi:tmp
