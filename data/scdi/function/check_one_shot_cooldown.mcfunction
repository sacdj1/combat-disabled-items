# called from check_one_shot.mcfunction only when one_shot_cooldown_enabled
# is on and this hit was already confirmed lethal. computes ticks since
# @s's last combat_end into a scratch score, then hands off to
# apply_check_one_shot_cooldown.mcfunction for the actual comparison
# against the configured cooldown (macro-driven since that's a live config
# value).
scoreboard players operation $one_shot_cd_age scdi_const = $ticks scdi_const
scoreboard players operation $one_shot_cd_age scdi_const -= @s scdi_last_combat_end_tick
execute store result storage scdi:tmp20 cooldown int 1 run data get storage scdi:config one_shot_cooldown 1
function scdi:apply_check_one_shot_cooldown with storage scdi:tmp20
