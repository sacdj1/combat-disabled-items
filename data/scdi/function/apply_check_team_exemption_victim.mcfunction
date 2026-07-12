# called with {myteam:N} still at @s (the victim), from
# check_team_exemption_victim.mcfunction. guesses the attacker as the
# nearest other player within melee range - same acceptable-risk proximity
# pattern as apply_check_team_exemption_attacker.mcfunction/dummy
# detection, for the same "advancement doesn't expose who dealt the
# damage" reason. if that guessed attacker shares the victim's team,
# team_tag_victim being off means: clear the "should tag" flag.
$execute if entity @p[distance=0.01..6,scores={scdi_team=$(myteam)}] run scoreboard players set $should_tag_victim scdi_const 0
