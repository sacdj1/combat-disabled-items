# public info/help screen - usage: /function scdi:help
# unlike scdi:menu, this is read-only and open to every player, not just ops.
tellraw @s ["",{"text":"===== ","color":"dark_gray"},{"text":"Combat Disabled Items","color":"red","bold":true},{"text":" - Help","color":"gold"},{"text":" =====","color":"dark_gray"}]

tellraw @s {"text":"When you're hit by another player, your dangerous escape items get disguised and can't be used for a short time - so you can't cheese a fight by flying/blinking away untouched.","color":"gray"}

tellraw @s ["",{"text":"Combat duration: ","color":"white"},{"score":{"name":"$duration","objective":"scdi_const"},"color":"yellow"},{"text":"ms","color":"yellow"}]

tellraw @s {"text":"Items disabled while tagged:","color":"white"}
execute if data storage scdi:config {disable_firework_rocket:1b} run tellraw @s {"text":"  - Firework rockets","color":"yellow"}
execute if data storage scdi:config {disable_wind_charge:1b} run tellraw @s {"text":"  - Wind charges","color":"yellow"}
execute if data storage scdi:config {disable_elytra:1b} run tellraw @s {"text":"  - Elytra","color":"yellow"}
function scdi:help_items_show

execute if data storage scdi:config {proximity_tagging:1b} run tellraw @s ["",{"text":"Proximity tagging is ","color":"gray"},{"text":"ON","color":"red","bold":true},{"text":" - just being within ","color":"gray"},{"nbt":"proximity_distance","storage":"scdi:config","interpret":false,"color":"yellow"},{"text":" blocks of an enemy keeps you tagged, even without a hit.","color":"gray"}]

execute if data storage scdi:config {proximity_tagging:1b} run tellraw @s ["",{"text":"  Teammates never proximity-tag each other: ","color":"gray"},{"text":"[Request]","color":"aqua","underlined":true,"click_event":{"action":"suggest_command","command":"/trigger ScdiTeamRequest"}},{"text":" the nearest player, they ","color":"gray"},{"text":"[Confirm]","color":"aqua","underlined":true,"click_event":{"action":"suggest_command","command":"/trigger ScdiTeamConfirm"}},{"text":", and ","color":"gray"},{"text":"[Leave]","color":"aqua","underlined":true,"click_event":{"action":"suggest_command","command":"/trigger ScdiTeamReset"}},{"text":" any time.","color":"gray"}]

execute if data storage scdi:config {pve_mode:1b} run tellraw @s ["",{"text":"PvE mode is ","color":"gray"},{"text":"ON","color":"red","bold":true},{"text":" - fighting mobs (in either direction) also triggers the lock, not just other players.","color":"gray"}]

execute if score @s scdi_tag matches 1 run function scdi:help_show_status

tellraw @s [{"text":"Admins: ","color":"dark_gray"},{"text":"[Open settings menu]","color":"aqua","underlined":true,"click_event":{"action":"run_command","command":"/function scdi:menu"}},{"text":" (op only)","color":"dark_gray"}]
