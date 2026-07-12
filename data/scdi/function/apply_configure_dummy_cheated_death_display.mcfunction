# called with {id:N} from spawn_dummy_cheated_death_display.mcfunction's
# "execute ... summon ... run function ... with storage ..." chain - @s is
# the text_display that command just created. same 3-second lifetime as
# the one-shot display (apply_expire_dummy_cheated_death_display.mcfunction) -
# a one-off announcement, not something meant to persist. scdi_owner_id
# lets apply_dummy_display_follow_tick2.mcfunction keep it glued to the
# dummy, since unlike the one-shot display this dummy isn't about to be
# removed - it's still very much alive.
data merge entity @s {Tags:["scdi_dummy_cheated_death_display"],billboard:"center",alignment:"center",text:{text:"⚔ Cheated Death!",color:"aqua",bold:true},background:1073741824,teleport_duration:3}
scoreboard players operation @s scdi_display_spawn_tick = $ticks scdi_const
$scoreboard players set @s scdi_owner_id $(id)
