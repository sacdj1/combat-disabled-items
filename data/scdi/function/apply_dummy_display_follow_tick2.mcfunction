# called with {id:N,cmd:"teleport"/"tp"} still at the dummy's own position,
# from apply_dummy_display_follow_tick.mcfunction. teleports each of its
# possible displays back onto its exact current position every tick - the
# same owner-id-matched technique the combat timer display uses for players
# (see apply_update_timer_display.mcfunction), needed now that a dummy can
# actually move (knockback, unless dummy_immobile is on). each line is a
# no-op if that particular display doesn't currently exist for this dummy
# (selector just matches nothing).
$execute at @s run $(cmd) @e[type=minecraft:text_display,tag=scdi_dummy_health_display,scores={scdi_owner_id=$(id)}] ~ ~2.3 ~
$execute at @s run $(cmd) @e[type=minecraft:text_display,tag=scdi_dummy_tag_display,scores={scdi_owner_id=$(id)}] ~ ~2.9 ~
$execute at @s run $(cmd) @e[type=minecraft:text_display,tag=scdi_dummy_one_shot_display,scores={scdi_owner_id=$(id)}] ~ ~2.6 ~
$execute at @s run $(cmd) @e[type=minecraft:text_display,tag=scdi_dummy_cheated_death_display,scores={scdi_owner_id=$(id)}] ~ ~3.2 ~
