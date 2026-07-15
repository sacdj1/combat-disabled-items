# called as+at @s = a dummy whose extinguish sequence timer just expired
# (see the tick-loop dispatch in tick.mcfunction). removes the placed
# water block (targeting the same feet-or-head spot recorded at start,
# see load.mcfunction's scdi_dummy_extinguish_y_offset comment) and the
# bucket, then clears the busy flag so dummy_look_tick resumes tracking
# the player again next tick.
execute if score @s scdi_dummy_extinguish_y_offset matches 0 run setblock ~ ~ ~ air
execute if score @s scdi_dummy_extinguish_y_offset matches 1 run setblock ~ ~1 ~ air
item replace entity @s weapon.mainhand with minecraft:air
scoreboard players set @s scdi_dummy_extinguishing 0
