# called at @s (the victim), from on_hurt_by_player.mcfunction, only when
# tag_victim is on. resolves whether THIS specific hit should tag the
# victim via a scratch flag, folding in both optional exemptions
# (team_tag_victim, no_tag_victim_on_one_shot) so they combine freely
# without a combinatorial explosion of execute lines in the caller.
scoreboard players set $should_tag_victim scdi_const 1

execute unless data storage scdi:config {team_tag_victim:1b} if score @s scdi_team matches 1.. run function scdi:check_team_exemption_victim
execute if data storage scdi:config {no_tag_victim_on_one_shot:1b} unless score @s scdi_tag matches 1 run function scdi:check_one_shot_exemption_victim

execute if score $should_tag_victim scdi_const matches 1 run function scdi:on_hurt_by_player_tag_only
