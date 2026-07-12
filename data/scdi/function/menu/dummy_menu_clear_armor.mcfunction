# unlike the other dummy management actions (heal, drop items, remove -
# all reversible or harmless), clearing armor permanently discards whatever
# was equipped with no way to get it back, so this one's restricted to
# operators or Creative-mode players on top of the usual allow_dummy_trigger
# gate, not open to every public-trigger player.
scoreboard players set $dummy_clear_authorized scdi_const 0
execute if entity @s[level=2..] run scoreboard players set $dummy_clear_authorized scdi_const 1
execute if entity @s[gamemode=creative] run scoreboard players set $dummy_clear_authorized scdi_const 1

execute unless data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"Dummy management is currently disabled by an admin.","color":"red"}
execute if data storage scdi:config {allow_dummy_trigger:1b} unless score $dummy_clear_authorized scdi_const matches 1 run tellraw @s {"text":"Only operators or players in Creative mode can clear a dummy's armor.","color":"red"}
execute if data storage scdi:config {allow_dummy_trigger:1b} if score $dummy_clear_authorized scdi_const matches 1 at @s unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"No test dummy within 10 blocks of you.","color":"red"}
execute if data storage scdi:config {allow_dummy_trigger:1b} if score $dummy_clear_authorized scdi_const matches 1 at @s as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] run data remove entity @s equipment.head
execute if data storage scdi:config {allow_dummy_trigger:1b} if score $dummy_clear_authorized scdi_const matches 1 at @s as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] run data remove entity @s equipment.chest
execute if data storage scdi:config {allow_dummy_trigger:1b} if score $dummy_clear_authorized scdi_const matches 1 at @s as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] run data remove entity @s equipment.legs
execute if data storage scdi:config {allow_dummy_trigger:1b} if score $dummy_clear_authorized scdi_const matches 1 at @s as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10,sort=nearest,limit=1] run data remove entity @s equipment.feet
execute if data storage scdi:config {allow_dummy_trigger:1b} if score $dummy_clear_authorized scdi_const matches 1 at @s if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"(✔) Dummy's armor cleared.","color":"green"}
execute if data storage scdi:config {allow_dummy_trigger:1b} if score $dummy_clear_authorized scdi_const matches 1 at @s if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run function scdi:dummy_menu_show
