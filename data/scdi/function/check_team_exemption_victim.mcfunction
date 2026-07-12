# called at @s (the victim) from maybe_tag_victim.mcfunction, only when
# team_tag_victim is off and @s has a team. reads @s's team as a clean
# number then hands off to the macro-driven comparison.
execute store result storage scdi:tmp22 myteam int 1 run scoreboard players get @s scdi_team
function scdi:apply_check_team_exemption_victim with storage scdi:tmp22
