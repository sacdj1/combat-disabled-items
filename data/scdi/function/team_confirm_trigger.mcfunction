# fired via /trigger ScdiTeamConfirm (any player, no op needed - see
# tick.mcfunction for dispatch/reset). accepts whoever most recently sent a
# team request (see team_request_trigger.mcfunction/apply_team_request.mcfunction)
# - only one pending request is tracked per player, confirming always
# accepts the most recent one, no per-request identity/list needed.
#
execute unless score @s scdi_team_requested_by_id matches 1.. run tellraw @s {"text":"You don't have a pending team request to confirm.","color":"red"}
execute if score @s scdi_team_requested_by_id matches 1.. store result storage scdi:tmp10 reqid int 1 run scoreboard players get @s scdi_team_requested_by_id
execute if score @s scdi_team_requested_by_id matches 1.. run function scdi:apply_team_confirm with storage scdi:tmp10
