# fired by the hurt_by_player advancement whenever another player deals damage to @s (the victim).
# tagging only actually applies if tag_victim is enabled (default: on - preserves the original
# always-tag-the-victim behavior). mirrors tag_attacker on the other side: turn this off for
# "only the attacker's items get disabled, not the victim's".

# checked before ANYTHING else, unconditionally - see check_restore_before_death.mcfunction
# for why (saves real disguised items from dropping as their disguise on
# death, independent of tag_victim/combat state).
function scdi:check_restore_before_death

# debugging aid (debug_hit_messages, default off - see /menu -> Detection) -
# raw Health straight from the entity, at the earliest point in the victim's
# own hit-reaction chain, to directly verify whether this advancement is
# firing on every real hit and whether Health is actually dropping each
# time - used to track down a reported "invulnerability while
# tagged/disguised" that doesn't clearly land on either specific mechanism
# tried so far.
execute if data storage scdi:config {debug_hit_messages:1b} run tellraw @a [{"text":"[invuln-dbg] victim=","color":"gray"},{"selector":"@s"},{"text":" Health=","color":"gray"},{"nbt":"Health","entity":"@s","interpret":false},{"text":" tag=","color":"gray"},{"score":{"name":"@s","objective":"scdi_tag"}},{"text":" tick=","color":"gray"},{"score":{"name":"$ticks","objective":"scdi_const"}}]

# one-shot detection: checked BEFORE tagging below, since that's what sets
# scdi_tag - "unless scdi_tag matches 1" here means @s wasn't already tagged
# going into this specific hit, i.e. this is the first hit of a fresh
# encounter. see check_one_shot.mcfunction for why this only lives on the
# hit-based path (never proximity) and can't name the attacker. NOTE: if
# the victim stays tagged through death (reset_on_death off, the default)
# and gets one-shot again shortly after respawning, this gate correctly
# skips the announcement for that second kill, since they weren't
# "untagged going in" - see no_tag_victim_on_one_shot below for the setting
# that keeps a one-shot victim from staying tagged in the first place, so
# repeated instant kills all still read as fresh encounters.
#
# one_shot_ignore_tag (default off) bypasses this gate entirely - every
# kill announces as a one-shot regardless of whether the victim was already
# tagged/mid-fight, not just a fresh-encounter kill.
execute if data storage scdi:config {one_shot_ignore_tag:1b} run function scdi:check_one_shot
execute unless data storage scdi:config {one_shot_ignore_tag:1b} unless score @s scdi_tag matches 1 run function scdi:check_one_shot

# the two optional exemptions below (team_tag_victim, no_tag_victim_on_one_shot)
# are folded into maybe_tag_victim.mcfunction rather than chained here, so
# they can combine freely without a combinatorial explosion of execute lines.
execute if data storage scdi:config {tag_victim:1b} at @s run function scdi:maybe_tag_victim

# reset the advancement so it can fire again on the next hit - always, regardless of tag_victim,
# so a later /data modify ... tag_victim set value 1b takes effect on the very next hit
advancement revoke @s only scdi:hurt_by_player

# clears the ranged-hit scratch flag (see on_hurt_by_player_ranged.mcfunction/
# on_hurt_by_player_tag_only.mcfunction) now that this invocation - melee or
# ranged, whichever led here - is fully done with it. always safe to zero
# here: melee left it at 0 already, ranged has already consumed it by now.
scoreboard players set $hit_was_ranged scdi_const 0
