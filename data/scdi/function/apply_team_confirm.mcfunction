# called with {reqid:N} from team_confirm_trigger.mcfunction, still @s =
# the confirmer. reqid is the requester's scdi_id - looked up via
# scores={scdi_id=$(reqid)} since a selector can't reference another
# entity's live score directly without this kind of macro substitution.
$execute unless entity @a[scores={scdi_id=$(reqid)}] run tellraw @s {"text":"That player is no longer online.","color":"red"}
$execute unless entity @a[scores={scdi_id=$(reqid)}] run scoreboard players reset @s scdi_team_requested_by_id

# hands off via "with storage scdi:tmp10" (still holding the same reqid
# this whole function was itself invoked with, untouched this whole time).
$execute if entity @a[scores={scdi_id=$(reqid)}] run function scdi:apply_team_confirm_established with storage scdi:tmp10
