# called with {equip_key:"head/chest/legs/feet",slot_arg:"armor.head/...",
# orig,snapshot,real_count,item,model,name,name_color,name_bold,name_italic,glint}
# from nullify_equipment_slot.mcfunction. armor slots (head/chest/legs/feet)
# can't use /item modify the way genuine hotbar slots can - see
# apply_nullify_armor.mcfunction for the full story (Mojang's player-only
# anti-dupe lock on equipment writes, since 1.17/MC-123307). this used to
# reuse apply_nullify_hotbar_slot, meaning EVERY custom item rule targeting
# an armor slot silently did nothing on a real player despite passing every
# detection check first - the same bug that broke elytra, just never
# noticed for plain armor since there's no built-in feature testing it the
# way disable_elytra does. same armor-stand relay fix, generalized to
# whichever slot via equip_key/slot_arg.
#
# also needs an explicit minecraft:equippable component (slot matching
# equip_key) - see apply_nullify_armor.mcfunction for the full story. an
# item replace onto an armor slot silently refuses whatever's being copied
# in if it isn't equippable there, which a deliberately-non-armor
# disguise_item never is by default. equippable alone still isn't enough -
# without an asset_id it writes fine but renders as nothing at all on the
# wearer; disguise_armor_model (see apply_nullify_armor.mcfunction) fills
# that in, same value reused for whichever slot this is. dyed_color is set
# ONCE here to a fixed red tint (16711680), same baseline as
# apply_nullify_armor.mcfunction - see that file for the full story on
# equip_sound (set to disguise_armor_equip_sound, a soft default instead of
# the harsh armor clink) and the optional recolor-on-flash feature.
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_armor_relay"]}
$execute as @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest] run data merge entity @s {equipment:{$(equip_key):{id:"$(item)",count:1,components:{"minecraft:custom_data":{"scdi":{"null":true,"orig":"$(orig)","snapshot":$(snapshot),"real_count":$(real_count)}},"minecraft:item_model":"$(model)","minecraft:custom_name":{"text":"$(name)","color":"$(name_color)","bold":$(name_bold),"italic":$(name_italic)},"minecraft:enchantment_glint_override":$(glint),"minecraft:dyed_color":16711680,"minecraft:equippable":{"slot":"$(equip_key)","asset_id":"$(armor_model)","equip_sound":"$(armor_sound)"}}}}}
$item replace entity @s $(slot_arg) from entity @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest] $(slot_arg)
kill @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest]

execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s [{"text":"[custom-armor] apply_nullify_equipment_slot done","color":"gray"}]
