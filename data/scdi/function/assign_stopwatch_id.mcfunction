# give @s the next free number and create their personal combat stopwatch: scdi:combat_<n>
scoreboard players add $next_id scdi_const 1
scoreboard players operation @s scdi_id = $next_id scdi_const

execute store result storage scdi:tmp id int 1 run scoreboard players get @s scdi_id
function scdi:create_stopwatch with storage scdi:tmp
