# three known outcomes: a real vanilla firework rocket, a real vanilla wind
# charge (both via a dedicated loot table - guaranteed zero-residue, see
# restore_mainhand.mcfunction history), or - anything else - a custom item
# from the disguise_targets list, which has no pre-authored loot table since
# it's arbitrary. that last case is rebuilt fresh on a relay entity instead
# of an in-place item modify with negated component keys, mirroring
# apply_restore_hotbar_slot.mcfunction's own fix (this file never got the
# same treatment at the time) - a "!component" negation doesn't clear an
# override and fall back to the item's own type default, it permanently
# REMOVES the component, masking the default too, and per the diagnostic
# testing that found this originally, the removal marker itself isn't even
# reliably cleared on a later attempt. mostly harmless for the keys this
# branch used to negate (custom_data/custom_name/enchantment_glint_override -
# absence is their normal state) EXCEPT custom_data: a stuck
# custom_data.scdi.null:true is what "already nulled" guards across this
# whole pack check for, so a restore that silently failed to clear it would
# make the item look permanently disguised to every future check, blocking
# it from ever being disguised OR restored again. building fresh sidesteps
# the whole question - a component never explicitly included in a fresh
# merge naturally falls back to the real item's own type default (or simply
# isn't there, for custom_data/custom_name/etc), no negation needed.
execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run loot replace entity @s weapon.mainhand loot scdi:blank_wind_charge
execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run loot replace entity @s weapon.mainhand loot scdi:blank_firework_rocket
$execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run item modify entity @s weapon.mainhand {"function":"minecraft:set_count","count":$(count)}
$execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run item modify entity @s weapon.mainhand [{"function":"minecraft:set_count","count":$(count)},{"function":"minecraft:set_components","components":{"minecraft:fireworks":$(fireworks)}}]
execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run return 0
execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run return 0
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_restore_relay"]}
$execute as @e[type=minecraft:armor_stand,tag=scdi_restore_relay,limit=1,sort=nearest] run data merge entity @s {equipment:{mainhand:{id:"$(orig)",count:$(count),components:$(snapshot)}}}
item replace entity @s weapon.mainhand from entity @e[type=minecraft:armor_stand,tag=scdi_restore_relay,limit=1,sort=nearest] weapon.mainhand
kill @e[type=minecraft:armor_stand,tag=scdi_restore_relay,limit=1,sort=nearest]
