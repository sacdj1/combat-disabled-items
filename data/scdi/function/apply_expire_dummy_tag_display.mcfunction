# called as each scdi_dummy_tag_display entity, every tick, from
# tick.mcfunction. much shorter-lived than the one-shot display (4 ticks,
# not 60) - it's just a quick flash confirming the hit registered, not an
# announcement worth lingering on. while alive, flashes yellow/white every
# other tick, the same first-second "just tagged" flash colors real players
# get (see combat_active.mcfunction's scdi_flash logic) - a whole
# red/gold/yellow fade like the real combat timer doesn't make sense for
# something this short-lived.
scoreboard players operation $tag_display_age scdi_const = $ticks scdi_const
scoreboard players operation $tag_display_age scdi_const -= @s scdi_display_spawn_tick
execute if score $tag_display_age scdi_const matches 4.. run kill @s
execute if score $tag_display_age scdi_const matches ..3 run function scdi:apply_update_dummy_tag_display_color
