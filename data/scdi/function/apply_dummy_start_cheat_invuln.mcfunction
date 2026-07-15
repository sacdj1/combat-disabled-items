# called as+at @s = a dummy that just cheated death (see
# apply_dummy_invincible_save.mcfunction), only when
# dummy_cheat_death_invulnerability is on (default). same idea as a real
# player's own brief post-respawn invulnerability - 1 second, effectively
# fully damage-immune.
#
# NOT implemented via Invulnerable:1b - that was the first attempt, and it
# broke hit detection entirely for the whole window: Invulnerable makes
# vanilla's Entity.hurt() bail out before any damage event is even
# processed, and this pack's ENTIRE hit-detection system relies on an
# advancement that only fires as a reaction to that event actually
# happening (see CONTRIBUTING.md). an invulnerable dummy generated no
# advancement at all, so hits during that window did nothing - no damage
# number, no DPS tracking, nothing - which read as "randomly unable to
# attack the dummy". minecraft:resistance at amplifier 4 (Resistance V)
# already caps damage reduction at 100% per vanilla's own formula, but
# unlike Invulnerable it reduces the damage AFTER the hurt event starts,
# so the advancement still fires normally and every other check still
# runs, it just doesn't inflict any HP loss. also self-expires, so no
# tick-loop cleanup needed the way Invulnerable required.
effect give @s minecraft:resistance 1 4 true
