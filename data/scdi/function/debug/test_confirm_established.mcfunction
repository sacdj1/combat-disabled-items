# usage: /function scdi:debug/test_confirm_established
# manually sets up scdi:tmp10 with the NEAREST OTHER player's scdi_id as
# reqid (same distance=0.01..10 pattern as team_request_trigger.mcfunction -
# excludes yourself), then calls apply_team_confirm_established directly,
# no surrounding execute chain, no real pending request needed. used to
# track down a bug where that function silently produced zero output when
# called - see apply_team_confirm_established.mcfunction's own header
# comment for how it was eventually fixed (rewritten to avoid a specific
# score-comparison pattern, root cause never fully pinned down).
execute unless entity @p[distance=0.01..10] run tellraw @s {"text":"No other player within 10 blocks of you to test with.","color":"red"}
execute at @s unless entity @p[distance=0.01..10] run return 0

execute unless score @s scdi_id matches 1.. run function scdi:assign_stopwatch_id
execute as @p[distance=0.01..10] unless score @s scdi_id matches 1.. run function scdi:assign_stopwatch_id

execute store result storage scdi:tmp10 reqid int 1 run scoreboard players get @p[distance=0.01..10] scdi_id
tellraw @a [{"text":"[test] about to call apply_team_confirm_established directly, targeting ","color":"gold"},{"selector":"@p[distance=0.01..10]"},{"text":" as the requester","color":"gold"}]
function scdi:apply_team_confirm_established with storage scdi:tmp10
tellraw @a {"text":"[test] returned from the call","color":"gold"}
