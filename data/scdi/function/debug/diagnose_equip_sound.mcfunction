# isolates whether minecraft:equippable's equip_sound field is even being
# consulted for a set_components color update, or if the armor-clink sound
# is hardcoded/unrelated to it - sets equip_sound to a sound that's
# DEFINITELY registered and DEFINITELY not the armor clink
# (entity.experience_orb.pickup - a distinct "ding"), then does a
# dyed_color update. if you hear the ding instead of the armor clink,
# equip_sound IS being read (and scdi:silent's problem is specifically
# that an unregistered id falls back to default rather than truly
# silencing). if you still hear the normal armor clink, equip_sound isn't
# being consulted for this write path at all.
# usage: wear any leather chestplate, then
# /function scdi:debug/diagnose_equip_sound
item modify entity @s armor.chest {"function":"minecraft:set_components","components":{"minecraft:equippable":{"slot":"chest","asset_id":"minecraft:leather","equip_sound":"minecraft:entity.experience_orb.pickup"}}}
tellraw @s {"text":"[sound-test] equip_sound set to experience_orb.pickup - now triggering a color update, listen closely","color":"yellow"}
item modify entity @s armor.chest {"function":"minecraft:set_components","components":{"minecraft:dyed_color":16776960}}
tellraw @s {"text":"[sound-test] DONE - did you hear a 'ding' (equip_sound respected) or the normal armor clink (equip_sound ignored for this write path)?","color":"green"}
