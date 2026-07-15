# fired by the hurt_by_player_ranged advancement (a ranged/projectile hit -
# arrow, trident, thrown potion, etc. - see hurt_by_player_ranged.json) -
# the melee-only counterpart to hurt_by_player.json since there's no way to
# inspect a damage source's type after the fact via commands, only at the
# advancement-criteria level. sets the shared scratch flag the melee path
# leaves at 0, then delegates into the exact same logic melee uses -
# on_hurt_by_player.mcfunction reads the flag (via
# on_hurt_by_player_tag_only.mcfunction's ranged_attacks_tag gate) and
# clears it again once done, so this doesn't leak into the next hit.
scoreboard players set $hit_was_ranged scdi_const 1
function scdi:on_hurt_by_player

# reset the advancement so it can fire again on the next ranged hit - the
# shared function above only revokes scdi:hurt_by_player (a harmless no-op
# here, since that one was never granted), this one is the actual grant to
# clear.
advancement revoke @s only scdi:hurt_by_player_ranged
