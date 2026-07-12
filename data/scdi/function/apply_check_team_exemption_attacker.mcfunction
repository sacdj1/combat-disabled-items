# called with {myteam:N} still at @s (the attacker), from
# check_team_exemption_attacker.mcfunction. guesses the victim as the
# nearest other player within melee range - if they share @s's team,
# team_tag_attacker being off means: clear the "should tag" flag.
$execute if entity @p[distance=0.01..6,scores={scdi_team=$(myteam)}] run scoreboard players set $should_tag_attacker scdi_const 0
