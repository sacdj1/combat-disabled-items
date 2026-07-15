# called as @s from apply_nullify_hotbar_slot.mcfunction/apply_nullify_mainhand.mcfunction/
# apply_nullify_offhand.mcfunction, right as a non-armor item (firework
# rocket, wind charge, elytra loose in inventory, or a mainhand/offhand
# custom item rule) gets disguised. same pattern as check_armor_warning.mcfunction -
# see load.mcfunction's disguise_inventory_warning/disguise_inventory_warning_sound
# comments for why this exists and why it's off by default (unlike the
# armor one).
execute unless score @s scdi_inventory_warning_pref matches 0.. store result score @s scdi_inventory_warning_pref run data get storage scdi:config disguise_inventory_warning 1
execute unless score @s scdi_inventory_warning_sound_pref matches 0.. store result score @s scdi_inventory_warning_sound_pref run data get storage scdi:config disguise_inventory_warning_sound 1
execute unless score @s scdi_inventory_warning_pref matches 1.. run return 0
execute if score @s scdi_inventory_warning_shown matches 1.. run return 0
scoreboard players set @s scdi_inventory_warning_shown 1
tellraw @s ["",{"text":"[SCDI] ","color":"red"},{"text":"An item has been disabled in your inventory.","color":"yellow"},{"text":" Toggle this message anytime with ","color":"gray"},{"text":"/trigger ScdiPlayerMenu","color":"aqua"},{"text":".","color":"gray"}]
# same delayed-sound mechanism as check_armor_warning.mcfunction (no equip
# sound to collide with here, but the same short delay is harmless and
# keeps both warnings consistent).
execute if score @s scdi_inventory_warning_sound_pref matches 1.. run scoreboard players operation @s scdi_inventory_warning_sound_at = $ticks scdi_const
execute if score @s scdi_inventory_warning_sound_pref matches 1.. run scoreboard players add @s scdi_inventory_warning_sound_at 15
