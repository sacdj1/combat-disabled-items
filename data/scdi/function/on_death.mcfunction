# update the baseline so this same death isn't detected again next tick
scoreboard players operation @s scdi_last_deaths = @s scdi_deaths

# only actually end combat early if reset_on_death is enabled (default: off)
execute if data storage scdi:config {reset_on_death:1b} if score @s scdi_tag matches 1 run function scdi:combat_end
