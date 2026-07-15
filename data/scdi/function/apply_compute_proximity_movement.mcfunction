# called as @a every tick (not throttled by proximity_interval - motion
# needs sampling every tick to mean anything, unlike the heavier checks
# proximity_interval exists to throttle), only while proximity_tagging AND
# proximity_role_by_movement are both on (see tick.mcfunction/load.mcfunction).
# Motion is the entity's own per-tick velocity, already tracked natively by
# the game - no need to diff positions across ticks ourselves. horizontal
# only (x/z), ignoring y, so falling/jumping in place doesn't skew the
# result toward "moving a lot". squared rather than a true magnitude (no
# sqrt available in commands) - fine since scdi_movement is only ever
# compared against another player's own value for ordering, never read as
# a real distance.
execute store result score $movement_mx scdi_const run data get entity @s Motion[0] 1000
execute store result score $movement_mz scdi_const run data get entity @s Motion[2] 1000
scoreboard players operation $movement_mx scdi_const *= $movement_mx scdi_const
scoreboard players operation $movement_mz scdi_const *= $movement_mz scdi_const
scoreboard players operation @s scdi_movement = $movement_mx scdi_const
scoreboard players operation @s scdi_movement += $movement_mz scdi_const
