# called at @s (the attacker) from maybe_tag_attacker.mcfunction, only when
# team_tag_attacker is off and @s has a team. reads @s's team as a clean
# number then hands off to the macro-driven comparison.
execute store result storage scdi:tmp21 myteam int 1 run scoreboard players get @s scdi_team
function scdi:apply_check_team_exemption_attacker with storage scdi:tmp21
