# called with {hp:N,max:N,id:N,dps:N} from
# apply_update_dummy_health_display.mcfunction, still as+at the dummy.
# re-merges its own display's text field every tick with the current
# values baked in as a native SNBT text component (two lines via "\n",
# works the same in a text component as anywhere else) - same reasoning as
# the combat timer display: text_display.text is static and has to be
# rewritten every tick, not something that re-resolves live on its own.
# matched via scdi_owner_id, not proximity - a dummy can now actually move
# (unless dummy_immobile is on), so "nearest display" would eventually
# grab the wrong one once two dummies got close together.
#
# dps is only shown once damage has actually been dealt this encounter (0
# otherwise) so a never-hit dummy doesn't show a meaningless "0 DPS" line -
# checked against the dps VALUE directly (data storage match on scdi:tmp9,
# still scoped to the dummy/outer context) rather than a score, since
# scdi_dummy_total_dmg only exists on the dummy, not on the display entity
# @s becomes below.
$execute if data storage scdi:tmp9 {dps:0} as @e[type=minecraft:text_display,tag=scdi_dummy_health_display,scores={scdi_owner_id=$(id)}] run data merge entity @s {text:{text:"❤ $(hp)/$(max)",color:"green",bold:true}}
$execute unless data storage scdi:tmp9 {dps:0} as @e[type=minecraft:text_display,tag=scdi_dummy_health_display,scores={scdi_owner_id=$(id)}] run data merge entity @s {text:{text:"❤ $(hp)/$(max)\n$(dps) DPS",color:"green",bold:true}}
