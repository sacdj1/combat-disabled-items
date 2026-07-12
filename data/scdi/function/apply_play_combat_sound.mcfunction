# "at @s" explicitly, since reward functions aren't guaranteed to carry a
# position context - without it "~ ~ ~" could resolve far from the player and
# the sound would be out of audible range
$execute at @s run playsound $(sound) master @s ~ ~ ~ $(volume) $(pitch)
