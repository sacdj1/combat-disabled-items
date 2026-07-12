# called with {reqid:N} from apply_team_confirm.mcfunction, still @s = the
# confirmer, once the requester is confirmed still online. if the requester
# has no team yet (fresh request, both at 0), they're assigned a new team
# number equal to their own scdi_id (guaranteed unique and non-zero, reusing
# the existing per-player id system rather than a separate counter) - then
# the confirmer just joins whatever team the requester now has. this way a
# third player requesting/confirming with either original member naturally
# joins the same team number, letting teams grow past two people.
#
# rewritten to avoid a specific pattern that was observed to make this
# ENTIRE function silently produce zero output when called, for reasons
# never fully pinned down despite extensive isolated testing (see
# CONTRIBUTING.md) - the previous version used
# "execute ... score @a[scores={scdi_id=$(reqid)}] scdi_team matches ..."
# (a live score check where the TARGET selector is itself filtered by a
# DIFFERENT score). this version reads the requester's id/team into plain
# scratch scores first via "as", then works with those - the same
# technique used successfully everywhere else in this pack.
#
scoreboard players set $confirm_req_team scdi_const 0
scoreboard players set $confirm_req_id scdi_const 0
$execute as @a[scores={scdi_id=$(reqid)}] run scoreboard players operation $confirm_req_team scdi_const = @s scdi_team
$execute as @a[scores={scdi_id=$(reqid)}] run scoreboard players operation $confirm_req_id scdi_const = @s scdi_id

# requester has no team yet (fresh request) - they get their own id as the
# new team number.
execute if score $confirm_req_team scdi_const matches ..0 run scoreboard players operation $confirm_req_team scdi_const = $confirm_req_id scdi_const
$execute as @a[scores={scdi_id=$(reqid)}] run scoreboard players operation @s scdi_team = $confirm_req_team scdi_const

# confirmer joins that same team number.
scoreboard players operation @s scdi_team = $confirm_req_team scdi_const

scoreboard players reset @s scdi_team_requested_by_id
$tellraw @s ["",{"text":"(✔) You're now teamed with ","color":"green"},{"selector":"@a[scores={scdi_id=$(reqid)}]"},{"text":"!","color":"green"}]
$tellraw @a[scores={scdi_id=$(reqid)}] ["",{"selector":"@s"},{"text":" accepted your team request!","color":"green"}]
