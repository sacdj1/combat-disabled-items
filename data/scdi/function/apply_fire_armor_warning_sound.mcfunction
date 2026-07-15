# called as+at a player from tick.mcfunction once their queued
# scdi_armor_warning_sound_at delay has elapsed. resets the score
# (unsets it, not just zeroes it - "matches 0.." in tick.mcfunction is how
# a pending one is detected) so this doesn't fire again next tick.
function scdi:play_armor_warning_sound
scoreboard players reset @s scdi_armor_warning_sound_at
