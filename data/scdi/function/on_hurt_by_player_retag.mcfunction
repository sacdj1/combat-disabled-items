# runs on every hit taken while already tagged - see on_hurt_by_player.mcfunction.
# whether this actually restarts the timer back to full is configurable - and
# either way, a killing blow should never extend the lock right as the player
# dies (reset_on_death already governs what happens to the timer on death).
execute store result score @s scdi_health run data get entity @s Health 100
execute if data storage scdi:config {retag_resets_timer:1b} unless score @s scdi_health matches ..0 run function scdi:restart_stopwatch
