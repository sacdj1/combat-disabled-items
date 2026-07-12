# fired via /trigger ScdiDummy (any player, no op needed - see
# tick.mcfunction for the dispatch/reset logic, same pattern as ScdiHelp/
# ScdiMenu). only actually spawns anything if allow_dummy_trigger is enabled
# by an admin (default: off, see load.mcfunction / /menu Misc page) -
# otherwise explains why nothing happened, so it doesn't look silently broken.
execute if data storage scdi:config {allow_dummy_trigger:1b} at @s summon minecraft:mannequin run function scdi:configure_new_dummy with storage scdi:config
execute if data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"(✔) Test dummy spawned.","color":"green"}
execute unless data storage scdi:config {allow_dummy_trigger:1b} run tellraw @s {"text":"Test dummy spawning is currently disabled by an admin.","color":"red"}
