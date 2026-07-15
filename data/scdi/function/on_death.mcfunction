# update the baseline so this same death isn't detected again next tick
scoreboard players operation @s scdi_last_deaths = @s scdi_deaths

# a real death is always a fresh-encounter boundary for one-shot detection
# (check_one_shot.mcfunction), regardless of reset_on_death/scdi_tag -
# unconditional and independent of combat_end's own reset of the same
# flag, since combat_end doesn't necessarily fire on this specific death
# (e.g. no_tag_victim_on_one_shot deliberately keeps scdi_tag from ever
# being set on a one-shot kill, specifically so a second quick kill right
# after respawning still reads as fresh - without this line, that repeat-
# one-shot detection would silently stop working the moment this
# encounter-freshness flag was added).
scoreboard players set @s scdi_one_shot_hit 0

# only actually end combat early if reset_on_death is enabled (default: off)
execute if data storage scdi:config {reset_on_death:1b} if score @s scdi_tag matches 1 run function scdi:combat_end
