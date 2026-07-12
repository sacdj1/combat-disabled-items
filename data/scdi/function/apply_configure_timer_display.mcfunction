# called with {id:N,teleport_duration:N} from spawn_timer_display.mcfunction's
# "execute ... summon minecraft:text_display run function ..." chain - @s
# here is the text_display that command just created, ambient position is
# its own (already 2.6 blocks above its owning player, per the "positioned"
# that ran before the summon). sets its visual NBT and, critically, its
# scdi_owner_id score - the latter is what every other lookup (per-tick
# teleport/text update, combat-end kill) matches against instead of guessing
# by proximity. teleport_duration is what makes
# apply_update_timer_display.mcfunction's every-tick position updates read
# as smooth tracking instead of a visible stutter - without it, each
# teleport is an instant snap (20 snaps/sec) - read live from
# timer_display_teleport_duration (see load.mcfunction) rather than
# hardcoded, though the default (3) should never actually need changing.
$data merge entity @s {Tags:["scdi_timer_display"],billboard:"center",alignment:"center",text:{text:""},background:1073741824,teleport_duration:$(teleport_duration),transformation:{translation:[0f,0f,0f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f],scale:[1f,1f,1f]}}
$scoreboard players set @s scdi_owner_id $(id)
