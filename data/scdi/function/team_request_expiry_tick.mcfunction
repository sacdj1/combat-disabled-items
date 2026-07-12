# entry point, called every tick from tick.mcfunction - sweeps expired
# pending team requests (see apply_team_request.mcfunction/
# team_request_trigger.mcfunction). cheap in practice since
# scdi_team_requested_by_id is normally unset for almost everyone.
execute as @a[scores={scdi_team_requested_by_id=1..}] run function scdi:apply_check_team_request_expiry
