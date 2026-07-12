# called with {timeout:N,reqid:N} still as the target (the player who has
# the pending request), from apply_check_team_request_expiry.mcfunction.
# $team_req_age was computed there, still live on scdi_const. tells both the
# target and the original requester (if still online) that the request
# wasn't accepted in time, then clears the pending state so it doesn't fire
# again next tick.
$execute if score $team_req_age scdi_const matches $(timeout).. run scoreboard players reset @s scdi_team_requested_by_id
$execute if score $team_req_age scdi_const matches $(timeout).. run tellraw @s {"text":"Your pending team request expired - ask again if you still want to team up.","color":"gray"}
$execute if score $team_req_age scdi_const matches $(timeout).. if entity @a[scores={scdi_id=$(reqid)}] run tellraw @a[scores={scdi_id=$(reqid)}] ["",{"text":"Your team request to ","color":"gray"},{"selector":"@s"},{"text":" was not accepted in time.","color":"gray"}]
