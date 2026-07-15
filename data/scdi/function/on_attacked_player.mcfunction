# fires as the ATTACKER whenever they deal damage to another player. only
# actually tags them if tag_attacker is enabled (default: on) - stops
# "hit and run" (attack, then immediately elytra away completely untouched).
# the two optional exemptions below (team_tag_attacker, no_tag_on_one_shot_kill)
# are folded into maybe_tag_attacker.mcfunction rather than chained here, so
# they can combine freely without a combinatorial explosion of execute lines.

# debugging aid (debug_hit_messages, default off - see on_hurt_by_player.mcfunction's
# matching victim-side log) - confirms this fired at all and when, from the
# attacker's side. doesn't know the victim's identity/health (the
# advancement doesn't expose that), just that a hit was successfully dealt.
execute if data storage scdi:config {debug_hit_messages:1b} run tellraw @a [{"text":"[invuln-dbg] attacker=","color":"gray"},{"selector":"@s"},{"text":" tag=","color":"gray"},{"score":{"name":"@s","objective":"scdi_tag"}},{"text":" tick=","color":"gray"},{"score":{"name":"$ticks","objective":"scdi_const"}}]

execute if data storage scdi:config {tag_attacker:1b} at @s run function scdi:maybe_tag_attacker

# reset the advancement so it can fire again on the next hit
advancement revoke @s only scdi:attacked_player

# see on_hurt_by_player.mcfunction for why this cleanup is always safe here
scoreboard players set $hit_was_ranged scdi_const 0
