# called with {equip_key:"head/chest/legs/feet",slot_arg:"armor.head/...",
# orig,count,snapshot} from restore_equipment_slot.mcfunction. armor slots
# can't use /item modify the way hotbar slots can - see
# apply_nullify_equipment_slot.mcfunction for the full story. unlike the
# hotbar restore version, no wind_charge/firework_rocket special-casing
# needed here - an armor slot can only ever hold a genuine custom item
# rule's target (a real armor piece), never a firework/wind charge.
# reconstruct the real item (real captured components merged back in) on a
# throwaway armor stand via a normal entity data merge, then /item replace
# the player's slot FROM the stand.
# clear the slot to empty FIRST, as its own step, before setting the real
# item back - see apply_restore_armor.mcfunction for why (Mojang's
# equippable-model render cache doesn't always refresh on an atomic
# occupied-to-occupied replace, leaving the disguise's model visually
# stuck on the wearer even though the real item is correctly back
# server-side).
$item replace entity @s $(slot_arg) with air
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_armor_relay"]}
$execute as @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest] run data merge entity @s {equipment:{$(equip_key):{id:"$(orig)",count:$(count),components:$(snapshot)}}}
$item replace entity @s $(slot_arg) from entity @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest] $(slot_arg)
kill @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest]

execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s [{"text":"[custom-armor] apply_restore_equipment_slot done","color":"gray"}]
