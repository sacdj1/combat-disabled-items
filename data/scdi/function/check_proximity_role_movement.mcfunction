# called with {dist:N} as @s (a player about to be proximity-tagged),
# only when proximity_role_by_movement is on - see
# check_proximity_role_gate.mcfunction/load.mcfunction. compares @s's own
# recent movement (scdi_movement, apply_compute_proximity_movement.mcfunction)
# against the NEAREST other player within dist blocks to decide a role for
# THIS specific pairing: strictly more movement = attacker (gated by
# tag_attacker), anything else including a tie (both standing still) =
# victim (gated by tag_victim) - "still = victim" by default, per the
# feature request this was built for.
scoreboard players operation $my_movement scdi_const = @s scdi_movement
scoreboard players set $other_movement scdi_const 0
$execute store result score $other_movement scdi_const as @a[distance=0.01..$(dist),sort=nearest,limit=1] run scoreboard players get @s scdi_movement

execute if score $my_movement scdi_const > $other_movement scdi_const if data storage scdi:config {tag_attacker:1b} run function scdi:on_proximity_tag
execute unless score $my_movement scdi_const > $other_movement scdi_const if data storage scdi:config {tag_victim:1b} run function scdi:on_proximity_tag
