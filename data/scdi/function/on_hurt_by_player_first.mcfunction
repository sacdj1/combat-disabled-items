# only runs the very moment a player transitions from untagged to tagged -
# see on_hurt_by_player.mcfunction. keeps the title/sound from spamming every
# single hit while already in combat; the timer itself still always resets.

# duration in whole seconds, for the subtitle text - reflects $duration live
# instead of hardcoding "30s", since the duration is configurable
scoreboard players operation @s scdi_sec = $duration scdi_const
scoreboard players operation @s scdi_sec /= $div scdi_const

execute if data storage scdi:config {show_tag_title:1b} run title @s times 0 20 5
execute if data storage scdi:config {show_tag_title:1b} run title @s title {"text":"⚔ In Combat!","color":"red","bold":true}
execute if data storage scdi:config {show_tag_title:1b} run title @s subtitle ["",{"text":"Items disabled for ","color":"gray"},{"score":{"name":"@s","objective":"scdi_sec"},"color":"gray"},{"text":"s","color":"gray"}]
function scdi:play_combat_sound
execute store result storage scdi:tmp4 id int 1 run scoreboard players get @s scdi_id
data modify storage scdi:tmp4 teleport_duration set from storage scdi:config timer_display_teleport_duration
function scdi:spawn_timer_display with storage scdi:tmp4
