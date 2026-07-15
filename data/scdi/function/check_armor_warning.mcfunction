# called as @s from apply_nullify_armor.mcfunction/apply_nullify_equipment_slot.mcfunction,
# right as a worn armor piece actually gets disguised. shows a one-time
# (per fresh encounter - scdi_armor_warning_shown, reset in combat_end.mcfunction)
# chat warning that armor has been disabled, optionally with a sound - see
# load.mcfunction's disguise_armor_warning/disguise_armor_warning_sound
# comments. per-player preferences (scdi_armor_warning_pref/
# scdi_armor_warning_sound_pref, toggleable via /trigger ScdiPlayerMenu -
# player_menu_show.mcfunction), not global switches - lazily seeded from
# the config defaults the first time read for a player who's never set
# their own preference (a score is either completely unset, matching no
# range at all, or explicitly 0/1 - "unless ... matches 0.." only catches
# the truly unset case, never overwriting a real preference already chosen).
execute unless score @s scdi_armor_warning_pref matches 0.. store result score @s scdi_armor_warning_pref run data get storage scdi:config disguise_armor_warning 1
execute unless score @s scdi_armor_warning_sound_pref matches 0.. store result score @s scdi_armor_warning_sound_pref run data get storage scdi:config disguise_armor_warning_sound 1
execute unless score @s scdi_armor_warning_pref matches 1.. run return 0
execute if score @s scdi_armor_warning_shown matches 1.. run return 0
scoreboard players set @s scdi_armor_warning_shown 1
tellraw @s ["",{"text":"[SCDI] ","color":"red"},{"text":"Your armor has been disabled.","color":"yellow"},{"text":" Toggle this message anytime with ","color":"gray"},{"text":"/trigger ScdiPlayerMenu","color":"aqua"},{"text":".","color":"gray"}]
# don't play the sound THIS tick - the disguise swap that triggered this
# warning also plays disguise_armor_equip_sound at this exact moment, which
# can mask it. queue it a short beat out instead (see
# scdi_armor_warning_sound_at's comment in load.mcfunction, fired from
# tick.mcfunction).
execute if score @s scdi_armor_warning_sound_pref matches 1.. run scoreboard players operation @s scdi_armor_warning_sound_at = $ticks scdi_const
execute if score @s scdi_armor_warning_sound_pref matches 1.. run scoreboard players add @s scdi_armor_warning_sound_at 15
