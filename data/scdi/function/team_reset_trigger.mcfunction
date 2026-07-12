# fired via /trigger ScdiTeamReset (any player, no op needed - see
# tick.mcfunction for dispatch/reset). just clears your own scdi_team back
# to "no team" (unset/0) - the only way to leave a team once
# request/confirm has put you in one, short of an admin doing it by hand.
execute if score @s scdi_team matches 1.. run tellraw @s {"text":"(✔) You've left your team.","color":"green"}
execute unless score @s scdi_team matches 1.. run tellraw @s {"text":"You're not currently teamed with anyone.","color":"red"}
scoreboard players reset @s scdi_team
