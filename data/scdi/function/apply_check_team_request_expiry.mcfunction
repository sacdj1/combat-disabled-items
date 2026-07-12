# called as a player with a pending team request (scdi_team_requested_by_id
# set), from team_request_expiry_tick.mcfunction. computes how long it's
# been pending into a scratch score, then hands off to
# apply_expire_team_request.mcfunction for the actual comparison against the
# configured timeout (macro-driven since that's a live config value).
scoreboard players operation $team_req_age scdi_const = $ticks scdi_const
scoreboard players operation $team_req_age scdi_const -= @s scdi_team_request_tick
execute store result storage scdi:tmp19 timeout int 1 run data get storage scdi:config team_request_timeout 1
execute store result storage scdi:tmp19 reqid int 1 run scoreboard players get @s scdi_team_requested_by_id
function scdi:apply_expire_team_request with storage scdi:tmp19
