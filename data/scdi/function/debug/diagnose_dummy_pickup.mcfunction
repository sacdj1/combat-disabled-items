# isolated test of the dummy item-pickup detection, step by step - dropped
# item entities are genuinely new territory for this pack (nothing in it has
# ever read from one before dummy_pickup_tick.mcfunction), so this exists to
# find out exactly which assumption is wrong instead of guessing blind.
# usage: stand within 1.5 blocks of BOTH a test dummy AND a dropped armor
# item, then /function scdi:debug/diagnose_dummy_pickup
tellraw @s {"text":"[pickup] dummy_pickup_items config:","color":"yellow"}
execute if data storage scdi:config {dummy_pickup_items:1b} run tellraw @s {"text":"[pickup]   dummy_pickup_items: TRUE","color":"green"}
execute unless data storage scdi:config {dummy_pickup_items:1b} run tellraw @s {"text":"[pickup]   dummy_pickup_items: FALSE - turn on via /menu (Misc) or /data modify storage scdi:config dummy_pickup_items set value 1b","color":"red"}

tellraw @s {"text":"[pickup] nearest dummy within 6 blocks of you:","color":"yellow"}
execute if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..6] run tellraw @s {"text":"[pickup]   FOUND","color":"green"}
execute unless entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..6] run tellraw @s {"text":"[pickup]   NONE within 6 blocks of you - move closer to a dummy before testing","color":"red"}

tellraw @s {"text":"[pickup] nearest item entity within 6 blocks of you:","color":"yellow"}
execute if entity @e[type=item,distance=..6] run tellraw @s {"text":"[pickup]   FOUND","color":"green"}
execute unless entity @e[type=item,distance=..6] run tellraw @s {"text":"[pickup]   NONE within 6 blocks of you - drop an armor piece nearby before testing","color":"red"}

tellraw @s {"text":"[pickup] FULL NBT of nearest item entity within 6 blocks (raw dump, no assumptions):","color":"yellow"}
tellraw @s [{"text":"[pickup]   ","color":"gray"},{"nbt":"","entity":"@e[type=item,distance=..6,sort=nearest,limit=1]","interpret":false}]

tellraw @s {"text":"[pickup] does that item have an Item.components.\"minecraft:equippable\" path at all?","color":"yellow"}
execute if data entity @e[type=item,distance=..6,sort=nearest,limit=1] Item.components."minecraft:equippable" run tellraw @s {"text":"[pickup]   YES","color":"green"}
execute unless data entity @e[type=item,distance=..6,sort=nearest,limit=1] Item.components."minecraft:equippable" run tellraw @s {"text":"[pickup]   NO - either the component doesn't exist under this name/path on this game version, or this isn't armor. Check the full NBT dump above for the real component key/structure.","color":"red"}

tellraw @s {"text":"[pickup] its slot value, if the path above resolved:","color":"yellow"}
execute if data entity @e[type=item,distance=..6,sort=nearest,limit=1] Item.components."minecraft:equippable".slot run tellraw @s [{"text":"[pickup]   slot = ","color":"gray"},{"nbt":"Item.components.\"minecraft:equippable\".slot","entity":"@e[type=item,distance=..6,sort=nearest,limit=1]","interpret":false}]
execute unless data entity @e[type=item,distance=..6,sort=nearest,limit=1] Item.components."minecraft:equippable".slot run tellraw @s {"text":"[pickup]   (no slot field to show)","color":"red"}

tellraw @s {"text":"[pickup] STEP: running the real dummy_pickup_tick chain now","color":"yellow"}
function scdi:dummy_pickup_tick
tellraw @s {"text":"[pickup] DONE - check the nearest dummy's equipment.chest/head/legs/feet by hand now: /data get entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..6,sort=nearest,limit=1] equipment","color":"green"}
