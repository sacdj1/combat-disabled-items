# fired via /trigger ScdiDummyMenu (any player, no op needed - see
# tick.mcfunction for dispatch/reset, same pattern as ScdiDummy). reuses the
# allow_dummy_trigger gate (default: off) rather than adding a separate
# setting - if public dummy spawning is allowed, public dummy management
# makes sense to allow too.
execute unless data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"Dummy management is currently disabled by an admin.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run tellraw @s {"text":"No test dummy within 10 blocks of you.","color":"red"}
execute at @s if data storage scdi:config {allow_dummy_trigger:1b} if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..10] run function scdi:dummy_menu_show
