# dumps every scdi-related text_display currently in the world, plus (this
# is the important part) EVERY text_display entity regardless of tag - if
# one of our spawn functions' "data merge entity @s {Tags:[...],...}" ever
# silently failed at runtime, the entity would still exist (summon always
# succeeds) but with no Tags, which is otherwise invisible to every other
# check in this pack (they all filter by tag). usage: get tagged into
# combat and/or have a dummy nearby, then
# /function scdi:debug/diagnose_displays
tellraw @s {"text":"[displays] config toggles:","color":"yellow"}
tellraw @s [{"text":"  show_timer_text_display = ","color":"gray"},{"nbt":"show_timer_text_display","storage":"scdi:config","interpret":false,"color":"yellow"}]
tellraw @s [{"text":"  dummy_announce_one_shot = ","color":"gray"},{"nbt":"dummy_announce_one_shot","storage":"scdi:config","interpret":false,"color":"yellow"}]
tellraw @s [{"text":"  dummy_show_health = ","color":"gray"},{"nbt":"dummy_show_health","storage":"scdi:config","interpret":false,"color":"yellow"}]
tellraw @s [{"text":"  tag_attacker = ","color":"gray"},{"nbt":"tag_attacker","storage":"scdi:config","interpret":false,"color":"yellow"}]

tellraw @s {"text":"[displays] tagged entities currently in world:","color":"yellow"}
execute as @e[type=minecraft:text_display,tag=scdi_timer_display] run tellraw @s [{"text":"  timer_display owner_id=","color":"gray"},{"score":{"name":"@s","objective":"scdi_owner_id"}},{"text":" text=","color":"gray"},{"nbt":"text","entity":"@s","interpret":false}]
execute as @e[type=minecraft:text_display,tag=scdi_dummy_health_display] run tellraw @s [{"text":"  dummy_health_display text=","color":"gray"},{"nbt":"text","entity":"@s","interpret":false}]
execute as @e[type=minecraft:text_display,tag=scdi_dummy_one_shot_display] run tellraw @s [{"text":"  dummy_one_shot_display text=","color":"gray"},{"nbt":"text","entity":"@s","interpret":false}]
execute as @e[type=minecraft:text_display,tag=scdi_dummy_tag_display] run tellraw @s [{"text":"  dummy_tag_display text=","color":"gray"},{"nbt":"text","entity":"@s","interpret":false}]

execute unless entity @e[type=minecraft:text_display,tag=scdi_timer_display] run tellraw @s {"text":"  (no timer_display entities exist right now)","color":"red"}
execute unless entity @e[type=minecraft:text_display,tag=scdi_dummy_one_shot_display] run tellraw @s {"text":"  (no dummy_one_shot_display entities exist right now)","color":"red"}
execute unless entity @e[type=minecraft:text_display,tag=scdi_dummy_tag_display] run tellraw @s {"text":"  (no dummy_tag_display entities exist right now)","color":"red"}

tellraw @s {"text":"[displays] EVERY text_display in the world regardless of tag (catches a silently-failed Tags merge):","color":"yellow"}
execute as @e[type=minecraft:text_display] run tellraw @s [{"text":"  entity Tags=","color":"gray"},{"nbt":"Tags","entity":"@s","interpret":false},{"text":" text=","color":"gray"},{"nbt":"text","entity":"@s","interpret":false}]
execute unless entity @e[type=minecraft:text_display] run tellraw @s {"text":"  (no text_display entities exist in the world at all right now)","color":"red"}

tellraw @s {"text":"[displays] DONE.","color":"green"}
