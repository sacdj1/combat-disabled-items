# called "as" a dummy that was just confirmed one-shot (see
# apply_check_dummy_hit.mcfunction) - ambient position is the dummy's
# own (it still exists at this exact moment, even though it's about to be
# removed from the world shortly after this same damage event finishes
# processing). spawns a temporary floating "ONE SHOT" text_display there,
# via the same "execute ... summon ... run function ..." technique used for
# the combat timer display (runs the configure step AS the newly created
# entity, no proximity guessing needed). passes the dummy's own
# scdi_dummy_id through for consistency with the other dummy displays,
# though this one is about to be removed alongside the dummy anyway.
execute store result storage scdi:tmp14 id int 1 run scoreboard players get @s scdi_dummy_id
execute at @s positioned ~ ~2.6 ~ summon minecraft:text_display run function scdi:apply_configure_dummy_one_shot_display with storage scdi:tmp14
