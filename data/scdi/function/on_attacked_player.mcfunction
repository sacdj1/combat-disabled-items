# fires as the ATTACKER whenever they deal damage to another player. only
# actually tags them if tag_attacker is enabled (default: on) - stops
# "hit and run" (attack, then immediately elytra away completely untouched).
# the two optional exemptions below (team_tag_attacker, no_tag_on_one_shot_kill)
# are folded into maybe_tag_attacker.mcfunction rather than chained here, so
# they can combine freely without a combinatorial explosion of execute lines.
execute if data storage scdi:config {tag_attacker:1b} at @s run function scdi:maybe_tag_attacker

# reset the advancement so it can fire again on the next hit
advancement revoke @s only scdi:attacked_player
