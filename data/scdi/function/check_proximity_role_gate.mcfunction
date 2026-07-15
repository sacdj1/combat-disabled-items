# called with {dist:N} from check_proximity_apply.mcfunction, as @s (a
# player who's about to be proximity-tagged), in place of calling
# on_proximity_tag directly. when proximity_role_by_movement is off
# (default), behaves identically to the original always-tag behavior. when
# on, hands off to check_proximity_role_movement.mcfunction to decide
# whether this specific player is playing the attacker or victim role for
# this pairing before deciding whether to actually tag.
execute unless data storage scdi:config {proximity_role_by_movement:1b} run function scdi:on_proximity_tag
$execute if data storage scdi:config {proximity_role_by_movement:1b} run function scdi:check_proximity_role_movement {dist:$(dist)}
