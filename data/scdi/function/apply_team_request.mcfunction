# called at @s (the requester) from team_request_trigger.mcfunction, once a
# nearby other player is confirmed to exist. both players need a scdi_id
# before the request can be recorded (it's what links requester -> target,
# the same per-player numeric id already used for stopwatches and timer
# display ownership) - assigned here if either doesn't have one yet.
execute unless score @s scdi_id matches 1.. run function scdi:assign_stopwatch_id
execute as @p[distance=0.01..10] unless score @s scdi_id matches 1.. run function scdi:assign_stopwatch_id

# record the request directly via a scoreboard operation - no macro/storage
# round-trip needed since both target (nearest other player) and source
# (@s, still bound to the requester here) are plain selectors. also stamps
# the current tick so team_request_expiry_tick.mcfunction can tell when
# this request goes stale (see load.mcfunction: team_request_timeout).
scoreboard players operation @p[distance=0.01..10] scdi_team_requested_by_id = @s scdi_id
scoreboard players operation @p[distance=0.01..10] scdi_team_request_tick = $ticks scdi_const

tellraw @s ["",{"text":"Team request sent to ","color":"gray"},{"selector":"@p[distance=0.01..10]"},{"text":".","color":"gray"}]
tellraw @p[distance=0.01..10] ["",{"selector":"@s"},{"text":" wants to team up with you! ","color":"gray"},{"text":"[Accept]","color":"green","bold":true,"underlined":true,"click_event":{"action":"suggest_command","command":"/trigger ScdiTeamConfirm"},"hover_event":{"action":"show_text","value":"Prefills the command - press Enter to confirm."}}]
