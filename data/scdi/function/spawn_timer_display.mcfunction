# called once, exactly when a player transitions from untagged to tagged (see
# on_hurt_by_player_tag_start.mcfunction), with {id:N,teleport_duration:N} -
# id is @s's scdi_id, teleport_duration is read live from
# timer_display_teleport_duration (see load.mcfunction) - only if
# show_timer_text_display is on. explicitly wrapped in "execute at @s"
# (not relying on ambient position context) since advancement reward
# functions aren't guaranteed to carry a position on their own - see
# play_combat_sound.mcfunction/README for the same lesson learned the hard
# way there.
#
# the duplicate-spawn guard checks scdi_owner_id, NOT proximity - a
# proximity-based "is there already a display near me" check breaks in
# multiplayer the instant two tagged players end up close to each other
# (each would find the OTHER's display and wrongly treat it as their own
# already existing, so neither ever gets one - or worse, once both DO have
# one, every other proximity-based lookup throughout this feature has that
# same cross-player mixup problem: the display nearest you isn't necessarily
# YOURS). scdi_owner_id, set on the display entity itself right after
# summoning it (matching @s's scdi_id), fixes this everywhere at once - see
# apply_update_timer_display.mcfunction and combat_end.mcfunction, both
# switched from distance-based lookups to this same owner-id match.
#
# "execute ... positioned ~ ~2.6 ~ summon minecraft:text_display run function
# ..." summons the entity and immediately runs the given function AS that
# new entity (@s = the new display) - this is what lets
# apply_configure_timer_display.mcfunction set its own scdi_owner_id and NBT
# without any proximity guessing about which entity is the one just created.
#
# the vertical lift (~2.6) is a real WORLD-SPACE position offset, not a
# transformation.translation - translation lives in the entity's own local
# space, and billboard:"center" constantly re-rotates that local space to
# face the viewer, so a translation-based offset doesn't stay a clean
# straight-up lift as you move around it, it swings/tilts with your viewing
# angle. an actual position offset has no such problem since it's resolved
# before any billboard rotation happens.
$execute at @s if data storage scdi:config {show_timer_text_display:1b} unless entity @e[type=minecraft:text_display,tag=scdi_timer_display,scores={scdi_owner_id=$(id)}] positioned ~ ~2.6 ~ summon minecraft:text_display run function scdi:apply_configure_timer_display {id:$(id),teleport_duration:$(teleport_duration)}
