# exemptions, checked before anything else happens - see
# on_hurt_by_player_tag_only.mcfunction/load.mcfunction for both.
execute if score @s scdi_untaggable matches 1.. run return 0
execute if data storage scdi:config {ignore_creative:1b} if entity @s[gamemode=creative] run return 0

# unlike hit-based retagging, proximity always keeps refreshing the timer
# regardless of retag_resets_timer (that setting is specifically about hits)
# - otherwise "stay disabled while close" wouldn't actually hold once the
# original timer ran out.
execute unless score @s scdi_tag matches 1 run function scdi:on_hurt_by_player_tag_start
execute if score @s scdi_tag matches 1 run function scdi:restart_stopwatch
scoreboard players set @s scdi_tag 1
