# called "as"+"at" a dummy (from dummy_pickup_tick.mcfunction) once it's
# confirmed a nearby item exists.
#
# STEP 1: try the item's own explicit minecraft:equippable component - the
# modern, data-driven way to know an item is armor and which slot it wants.
# only ever present if something explicitly overrode it (custom/modded
# items mostly) - a plain item's stored NBT only contains EXPLICIT component
# overrides, not its full resolved type defaults, confirmed empirically via
# debug/diagnose_dummy_pickup: a freshly /given iron chestplate has no
# "components" key in its NBT at all. so this step is basically dead for
# standard vanilla armor, but free to keep for custom items that do set it.
data remove storage scdi:tmp6 slot
execute if data entity @e[type=item,distance=..1.5,sort=nearest,limit=1] Item.components."minecraft:equippable".slot run data modify storage scdi:tmp6 slot set from entity @e[type=item,distance=..1.5,sort=nearest,limit=1] Item.components."minecraft:equippable".slot

# STEP 2: fall back to matching real vanilla armor item ids directly, since
# STEP 1 essentially never fires for them. only ever runs if STEP 1 didn't
# already resolve a slot.
execute unless data storage scdi:tmp6 slot run function scdi:apply_dummy_pickup_vanilla_fallback

# only for the 4 real armor slots - minecraft:equippable (STEP 1) also
# covers held/off-hand equippables (slot "mainhand"/"offhand") and
# horse/wolf "body" armor, none of which "pick up armor and wear it" was
# asking for, so those are deliberately excluded rather than blindly
# equipping anything equippable.
execute if data storage scdi:tmp6 {slot:"head"} run function scdi:apply_dummy_equip_item with storage scdi:tmp6
execute if data storage scdi:tmp6 {slot:"chest"} run function scdi:apply_dummy_equip_item with storage scdi:tmp6
execute if data storage scdi:tmp6 {slot:"legs"} run function scdi:apply_dummy_equip_item with storage scdi:tmp6
execute if data storage scdi:tmp6 {slot:"feet"} run function scdi:apply_dummy_equip_item with storage scdi:tmp6
