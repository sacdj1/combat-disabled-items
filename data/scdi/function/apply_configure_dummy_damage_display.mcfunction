# called with {id:N,whole:N,tenths:N} from spawn_dummy_damage_display.mcfunction's
# "execute ... summon ... run function ... with storage ..." chain - @s is
# the text_display that command just created. "-whole.tenths" (e.g. "-4.5")
# instead of just a truncated whole number, so hits under 1 full HP still
# show something meaningful rather than rounding away to nothing. no
# background box (unlike the other dummy displays) since a plain floating
# number reads more like an RPG damage popup without one.
# teleport_duration:2 (not 1) since apply_expire_dummy_damage_display.mcfunction
# now actively nudges this upward every tick - a couple ticks of
# interpolation smooths that into a continuous rise instead of visible
# per-tick steps. scdi_owner_id isn't needed here (unlike the other dummy
# displays) since this one no longer tracks the dummy's position after
# spawning - it just floats up on its own.
$data merge entity @s {Tags:["scdi_dummy_damage_display"],billboard:"center",alignment:"center",text:{text:"-$(whole).$(tenths)",color:"red",bold:true},background:0,teleport_duration:2}
scoreboard players operation @s scdi_display_spawn_tick = $ticks scdi_const
