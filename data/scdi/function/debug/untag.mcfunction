# debug: force @s out of combat immediately, regardless of how much time is
# left on their timer - restores any nulled item on the spot.
# usage: /function scdi:debug/untag         (untags yourself)
#        /execute as <player> run function scdi:debug/untag (untags someone else)
function scdi:combat_end
