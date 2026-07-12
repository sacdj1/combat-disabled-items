# called with {cooldown:N} still as @s (the victim), from
# check_one_shot_cooldown.mcfunction. $one_shot_cd_age was computed there,
# still live on scdi_const - only announces if @s has been out of combat
# for at least that many ticks.
$execute if score $one_shot_cd_age scdi_const matches $(cooldown).. run function scdi:announce_one_shot
