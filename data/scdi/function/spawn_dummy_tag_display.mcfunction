# called "as" a dummy that just tagged its attacker (see
# on_attacked_entity.mcfunction) - the only feedback a hit on a dummy
# otherwise gives is the ACTUAL tagged player's own title/sound/actionbar;
# nothing on the dummy itself showed that hitting it had done anything.
# same "execute ... summon ... run function ..." technique as the one-shot
# display, just a different message/tag. passes the dummy's own
# scdi_dummy_id through for consistency with the other dummy displays.
execute store result storage scdi:tmp15 id int 1 run scoreboard players get @s scdi_dummy_id
execute at @s positioned ~ ~2.9 ~ summon minecraft:text_display run function scdi:apply_configure_dummy_tag_display with storage scdi:tmp15
