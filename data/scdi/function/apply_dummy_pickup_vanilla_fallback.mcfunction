# called from apply_dummy_pickup_item.mcfunction (still as+at the dummy)
# only when the item's own minecraft:equippable component didn't resolve a
# slot - matches every standard vanilla armor piece by its real item id
# directly, using the same "if data entity <selector> {filter}" pattern
# already proven reliable elsewhere in this pack (check_custom_item_slots.mcfunction
# has a note that the selector-based "if items entity" equivalent was
# tested and found to never actually match on this game version - this
# avoids that path entirely). doesn't cover custom/modded armor without a
# minecraft:equippable component of its own - nothing further to fall back
# to for those without hardcoding an unbounded item list.
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:leather_helmet"}} run data modify storage scdi:tmp6 slot set value "head"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:chainmail_helmet"}} run data modify storage scdi:tmp6 slot set value "head"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:iron_helmet"}} run data modify storage scdi:tmp6 slot set value "head"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:golden_helmet"}} run data modify storage scdi:tmp6 slot set value "head"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:diamond_helmet"}} run data modify storage scdi:tmp6 slot set value "head"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:netherite_helmet"}} run data modify storage scdi:tmp6 slot set value "head"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:turtle_helmet"}} run data modify storage scdi:tmp6 slot set value "head"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:leather_chestplate"}} run data modify storage scdi:tmp6 slot set value "chest"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:chainmail_chestplate"}} run data modify storage scdi:tmp6 slot set value "chest"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:iron_chestplate"}} run data modify storage scdi:tmp6 slot set value "chest"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:golden_chestplate"}} run data modify storage scdi:tmp6 slot set value "chest"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:diamond_chestplate"}} run data modify storage scdi:tmp6 slot set value "chest"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:netherite_chestplate"}} run data modify storage scdi:tmp6 slot set value "chest"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:leather_leggings"}} run data modify storage scdi:tmp6 slot set value "legs"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:chainmail_leggings"}} run data modify storage scdi:tmp6 slot set value "legs"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:iron_leggings"}} run data modify storage scdi:tmp6 slot set value "legs"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:golden_leggings"}} run data modify storage scdi:tmp6 slot set value "legs"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:diamond_leggings"}} run data modify storage scdi:tmp6 slot set value "legs"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:netherite_leggings"}} run data modify storage scdi:tmp6 slot set value "legs"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:leather_boots"}} run data modify storage scdi:tmp6 slot set value "feet"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:chainmail_boots"}} run data modify storage scdi:tmp6 slot set value "feet"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:iron_boots"}} run data modify storage scdi:tmp6 slot set value "feet"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:golden_boots"}} run data modify storage scdi:tmp6 slot set value "feet"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:diamond_boots"}} run data modify storage scdi:tmp6 slot set value "feet"
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] {Item:{id:"minecraft:netherite_boots"}} run data modify storage scdi:tmp6 slot set value "feet"
