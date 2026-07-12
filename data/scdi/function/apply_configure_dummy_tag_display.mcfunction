# called with {id:N} from spawn_dummy_tag_display.mcfunction's "execute ...
# summon ... run function ... with storage ..." chain - @s is the
# text_display that command just created. brief (4 ticks - see
# apply_expire_dummy_tag_display.mcfunction), yellow/white flashing
# feedback that a hit registered, not a lingering announcement - just a
# different tag/message from the one-shot display so the two never get
# confused with each other. scdi_owner_id lets
# apply_dummy_display_follow_tick2.mcfunction keep it glued to the dummy
# for its short lifetime.
data merge entity @s {Tags:["scdi_dummy_tag_display"],billboard:"center",alignment:"center",text:{text:"⚔ Attacker Tagged!",color:"yellow",bold:true},background:1073741824,teleport_duration:1}
scoreboard players operation @s scdi_display_spawn_tick = $ticks scdi_const
$scoreboard players set @s scdi_owner_id $(id)
