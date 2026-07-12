# called from on_hurt_by_player.mcfunction (the victim/hit-detection path)
# ONLY when @s was NOT already tagged going into this specific hit - i.e.
# this is the first hit of a fresh encounter. deliberately hit-based only,
# never fires from proximity_tagging (see on_proximity_tag.mcfunction, which
# has its own separate untagged->tagged transition unrelated to actually
# taking damage) - proximity tagging isn't "getting hit" at all, so it has
# nothing meaningful to report here.
#
# "untagged, then one hit, then dead" is the clearest signal of a one-shot
# kill available without needing the attacker's identity - the
# entity_hurt_player advancement this whole chain runs from doesn't expose
# who dealt the damage (only that it was *a* player - see the README's note
# on tag_attacker/tag_victim for the same limitation), so the announcement
# names the victim only, not who did it.
execute if data storage scdi:config {announce_one_shot:1b} store result score @s scdi_health run data get entity @s Health 100

# optional tightening (one_shot_cooldown_enabled, off by default): also
# require @s to have been out of combat for at least one_shot_cooldown
# ticks, closing the "get them low, wait out the tag, finish them off
# later" loophole - a fresh-out-the-gate untagged hit isn't enough on its
# own anymore. scdi_last_combat_end_tick is unset (0) for a player who has
# never been in combat at all, which trivially satisfies "long enough ago".
execute if data storage scdi:config {announce_one_shot:1b} unless data storage scdi:config {one_shot_cooldown_enabled:1b} if score @s scdi_health matches ..0 run function scdi:announce_one_shot
execute if data storage scdi:config {announce_one_shot:1b} if data storage scdi:config {one_shot_cooldown_enabled:1b} if score @s scdi_health matches ..0 run function scdi:check_one_shot_cooldown
