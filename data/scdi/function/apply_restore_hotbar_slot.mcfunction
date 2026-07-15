$execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run loot replace entity @s $(slot_arg) loot scdi:blank_wind_charge
$execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run loot replace entity @s $(slot_arg) loot scdi:blank_firework_rocket
$execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run item modify entity @s $(slot_arg) {"function":"minecraft:set_count","count":$(count)}
$execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run item modify entity @s $(slot_arg) [{"function":"minecraft:set_count","count":$(count)},{"function":"minecraft:set_components","components":{"minecraft:fireworks":$(fireworks)}}]
# rebuilt fresh on a relay entity instead of an in-place item modify with
# negated component keys - a "!component" negation doesn't clear an
# override and fall back to the item's own type default, it permanently
# REMOVES the component, masking the default too. that's harmless for
# components with no meaningful default (custom_data/custom_name/
# enchantment_glint_override/item_model/dyed_color/enchantments - absence
# is their normal state), but minecraft:equippable is one every armor-slot
# item genuinely NEEDS from its own type default to be wearable at all - an
# earlier version of this file negated it, silently turning every disguised
# elytra/armor piece restored via this path (loose in inventory, not still
# worn - scan_inventory/restore_inventory) into a permanently unwearable
# item, id and every other component correct, just missing equippable
# entirely. building fresh here instead - same technique
# apply_restore_armor.mcfunction/apply_restore_equipment_slot.mcfunction
# already use for the still-worn case - sidesteps the whole question: a
# component never explicitly included in a fresh merge naturally falls
# back to the real item's own type default, no negation needed.
execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run return 0
execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run return 0
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_restore_relay"]}
$execute as @e[type=minecraft:armor_stand,tag=scdi_restore_relay,limit=1,sort=nearest] run data merge entity @s {equipment:{mainhand:{id:"$(orig)",count:$(count),components:$(snapshot)}}}
$item replace entity @s $(slot_arg) from entity @e[type=minecraft:armor_stand,tag=scdi_restore_relay,limit=1,sort=nearest] weapon.mainhand
kill @e[type=minecraft:armor_stand,tag=scdi_restore_relay,limit=1,sort=nearest]
