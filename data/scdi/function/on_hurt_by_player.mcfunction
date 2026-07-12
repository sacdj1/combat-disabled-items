# fired by the hurt_by_player advancement whenever another player deals damage to @s (the victim).
# tagging only actually applies if tag_victim is enabled (default: on - preserves the original
# always-tag-the-victim behavior). mirrors tag_attacker on the other side: turn this off for
# "only the attacker's items get disabled, not the victim's".

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
