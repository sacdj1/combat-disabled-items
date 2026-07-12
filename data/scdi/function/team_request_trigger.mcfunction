# fired via /trigger ScdiTeamRequest (any player, no op needed - see
# tick.mcfunction for dispatch/reset, same pattern as ScdiHelp/ScdiMenu).
# always public, no admin gate - scdi_team was already freely settable by
# anyone with command access via raw /scoreboard commands (see load.mcfunction),
# this is just a friendlier way for players to do the same thing themselves,
# not new power. requests to team with the nearest OTHER player within 10
# blocks - distance=0.01.. excludes yourself (you're always at distance 0 to
# your own position, same trick used in check_proximity_apply.mcfunction).
# doesn't establish anything by itself - the target has to separately
# /trigger ScdiTeamConfirm to accept.
execute unless entity @p[distance=0.01..10] run tellraw @s {"text":"No other player within 10 blocks of you to team up with.","color":"red"}
execute at @s if entity @p[distance=0.01..10] run function scdi:apply_team_request
