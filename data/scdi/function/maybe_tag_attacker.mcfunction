# called at @s (the attacker), from on_attacked_player.mcfunction, only
# when tag_attacker is on. resolves whether THIS specific hit should tag
# the attacker via a scratch flag, folding in both optional exemptions
# (team_tag_attacker, no_tag_on_one_shot_kill) so they combine freely
# without a combinatorial explosion of execute lines in the caller. both
# need to guess who the victim was (nearest other player in melee range) -
# the hit-detection advancement this whole chain runs from doesn't expose
# that directly, same acceptable-risk proximity pattern already used for
# dummy detection (on_attacked_entity.mcfunction).
scoreboard players set $should_tag_attacker scdi_const 1

execute unless data storage scdi:config {team_tag_attacker:1b} if score @s scdi_team matches 1.. run function scdi:check_team_exemption_attacker
execute if data storage scdi:config {no_tag_on_one_shot_kill:1b} run function scdi:check_one_shot_exemption_attacker

execute if score $should_tag_attacker scdi_const matches 1 run function scdi:on_hurt_by_player_tag_only
