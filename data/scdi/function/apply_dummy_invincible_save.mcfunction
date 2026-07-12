# called at @s (the dummy) from apply_dummy_invincible_segment_check.mcfunction,
# only once the ENTIRE large health pool is exhausted (every 20-point
# segment already cheated via apply_dummy_invincible_segment_topoff.mcfunction
# - see there for the normal, repeating case). this is the true last-resort
# backstop: heals straight back to full with a "cheated death" particle
# burst instead of dropping items and actually dying, and resets the floor
# back to the start of the cycle (max-20) so segment top-offs resume
# working normally on the next hit. runs synchronously in the SAME
# damage-processing step as the hit itself (advancement rewards fire as a
# direct reaction to the damage already being applied), reliably winning
# the race against the game's own internal death handling in practice, the
# same technique this pack used exclusively for every dummy before
# drop-on-death became the default.
# resets scdi_dummy_hit so DPS tracking starts a fresh encounter, same as
# passive regen/[Heal to full] bringing it back to full health.
particle minecraft:totem_of_undying ~ ~1 ~ 0.5 0.5 0.5 0.1 30 force
tellraw @a {"text":"⚔ Dummy's health pool was fully exhausted - regenerated from scratch!","color":"gold","bold":true}
execute store result entity @s Health float 1 run attribute @s minecraft:max_health get
scoreboard players set @s scdi_dummy_hit 0
execute store result score @s scdi_dummy_invincible_floor run attribute @s minecraft:max_health get
scoreboard players remove @s scdi_dummy_invincible_floor 20
