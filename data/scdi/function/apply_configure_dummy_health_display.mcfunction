# called with {id:N} from spawn_dummy_health_display.mcfunction's "execute
# ... summon ... run function ... with storage ..." chain - @s is the
# text_display that command just created. text starts blank -
# dummy_health_display_tick.mcfunction (called every tick from
# tick.mcfunction) fills it in. scdi_owner_id matches the owning dummy's
# scdi_dummy_id - apply_dummy_display_follow_tick2.mcfunction teleports it
# onto that exact dummy every tick, the same owner-id technique the combat
# timer display uses for players (proximity alone breaks the instant two
# dummies end up near each other, or a dummy actually moves).
data merge entity @s {Tags:["scdi_dummy_health_display"],billboard:"center",alignment:"center",text:{text:""},background:1073741824,teleport_duration:3}
$scoreboard players set @s scdi_owner_id $(id)
