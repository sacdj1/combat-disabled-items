# called with {sec:N,color:"...",cmd:"teleport"/"tp",id:N} from
# combat_active.mcfunction (all four already resolved there - id is @s's own
# scdi_id, cmd from the teleport_command config, see load.mcfunction). does
# two things every tick while tagged, both targeting the display via an
# EXACT scdi_owner_id match (set once at spawn - see
# apply_configure_timer_display.mcfunction) rather than "nearest
# scdi_timer_display entity to me", which broke in multiplayer: with two
# tagged players near each other, "nearest" doesn't reliably mean "mine" -
# each player's tick could grab the OTHER's display, teleporting it away
# from its actual owner or overwriting their text.
#  1. teleport the display to ~ ~2.6 ~ of @s (a real world-space position
#     offset above @s's feet, NOT a transformation.translation - see
#     spawn_timer_display.mcfunction for why) using whichever command
#     teleport_command currently names - "ride"/"mount" was tried twice,
#     including after fixing the text-field syntax bug in case that was the
#     real cause, and still never stuck either time - confirmed not working
#     for this game version/entity combination.
#  2. re-merge its text field with the current countdown + color baked in as
#     a native SNBT text component (NOT a quoted JSON string - "text":"..."
#     style, unquoted keys, is what this game version's text_display.text
#     field actually wants) since it's a static value that has to be
#     rewritten every tick, not something that re-resolves a live
#     {"score":...}/color on its own.
$execute at @s run $(cmd) @e[type=minecraft:text_display,tag=scdi_timer_display,scores={scdi_owner_id=$(id)}] ~ ~2.6 ~
$execute as @e[type=minecraft:text_display,tag=scdi_timer_display,scores={scdi_owner_id=$(id)}] run data merge entity @s {text:{text:"⚔ $(sec)s",color:"$(color)",bold:true}}
