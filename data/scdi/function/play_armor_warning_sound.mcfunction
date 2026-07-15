# called as @s (the warned player) from check_armor_warning.mcfunction.
# same shape as play_combat_sound.mcfunction, but sourced from its own
# dedicated disguise_armor_warning_sound_id instead of combat_sound - still
# shares combat_pitch/combat_volume. apply_play_combat_sound.mcfunction
# already targets "master @s", so this only ever plays to the one warned
# player, never broadcast. the player's own ScdiArmorWarningSoundId choice
# (set via /trigger ScdiPlayerMenu - player_menu_show.mcfunction/
# player_menu_action_dispatch.mcfunction) overrides the OP-configured
# default if they've ever picked one.
# pitch/volume likewise fall back to combat_pitch/combat_volume, overridden
# by the player's own ScdiArmorWarningSoundPitch/ScdiArmorWarningSoundVolume
# if set (own pick, separate from the inventory warning's).
data modify storage scdi:tmp sound set from storage scdi:config disguise_armor_warning_sound_id
execute if data entity @s ScdiArmorWarningSoundId run data modify storage scdi:tmp sound set from entity @s ScdiArmorWarningSoundId
data modify storage scdi:tmp pitch set from storage scdi:config combat_pitch
execute if data entity @s ScdiArmorWarningSoundPitch run data modify storage scdi:tmp pitch set from entity @s ScdiArmorWarningSoundPitch
data modify storage scdi:tmp volume set from storage scdi:config combat_volume
execute if data entity @s ScdiArmorWarningSoundVolume run data modify storage scdi:tmp volume set from entity @s ScdiArmorWarningSoundVolume
function scdi:apply_play_combat_sound with storage scdi:tmp
