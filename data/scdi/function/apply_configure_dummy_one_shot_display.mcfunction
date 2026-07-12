# called with {id:N} from spawn_dummy_one_shot_display.mcfunction's
# "execute ... summon ... run function ... with storage ..." chain - @s is
# the text_display that command just created. scdi_display_spawn_tick
# records the global tick counter at creation, so the sweep in
# tick.mcfunction (apply_expire_one_shot_display.mcfunction) knows when to
# kill it - this display is a one-off announcement, not something meant to
# persist, but scdi_owner_id still lets apply_dummy_display_follow_tick2.mcfunction
# keep it glued to the dummy for its brief 3-second lifetime.
data merge entity @s {Tags:["scdi_dummy_one_shot_display"],billboard:"center",alignment:"center",text:{text:"ONE SHOT",color:"red",bold:true},background:1073741824,teleport_duration:3}
scoreboard players operation @s scdi_display_spawn_tick = $ticks scdi_const
$scoreboard players set @s scdi_owner_id $(id)
