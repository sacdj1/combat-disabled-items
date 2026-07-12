# three known outcomes: a real vanilla firework rocket, a real vanilla wind
# charge (both via a dedicated loot table - guaranteed zero-residue, see
# restore_mainhand.mcfunction history), or - anything else - a custom item
# from the disguise_targets list, which has no pre-authored loot table since
# it's arbitrary. that last case instead reconstructs via set_item (carries
# our tracking junk forward) + reapplying the FULL captured snapshot on top
# (restores whatever was really there - enchantments, name, everything) +
# explicitly removing just the 4 keys we know we added ourselves.
execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run loot replace entity @s weapon.mainhand loot scdi:blank_wind_charge
execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run loot replace entity @s weapon.mainhand loot scdi:blank_firework_rocket
$execute if data storage scdi:tmp {orig:"minecraft:wind_charge"} run item modify entity @s weapon.mainhand {"function":"minecraft:set_count","count":$(count)}
$execute if data storage scdi:tmp {orig:"minecraft:firework_rocket"} run item modify entity @s weapon.mainhand [{"function":"minecraft:set_count","count":$(count)},{"function":"minecraft:set_components","components":{"minecraft:fireworks":$(fireworks)}}]
# order matters here: junk removal runs BEFORE the snapshot is reapplied, not
# after. removing first and reapplying second means whatever the ORIGINAL
# item really had for custom_name/custom_data/enchantment_glint_override
# (if anything) ends up as the final, correct value - the earlier
# remove-after-reapply order was actively destroying real original names/data
# whenever removal happened to work. item_model is EXPLICITLY set at the very
# end regardless, since "!key" removal for it was never confirmed reliable
# and a leftover barrier model is what makes a restored item look invisible.
$execute unless data storage scdi:tmp {orig:"minecraft:wind_charge"} unless data storage scdi:tmp {orig:"minecraft:firework_rocket"} run item modify entity @s weapon.mainhand [{"function":"minecraft:set_item","item":"$(orig)"},{"function":"minecraft:set_count","count":$(count)},{"function":"minecraft:set_components","components":{"!minecraft:custom_data":{},"!minecraft:custom_name":{},"!minecraft:enchantment_glint_override":{},"!minecraft:item_model":{}}},{"function":"minecraft:set_components","components":$(snapshot)},{"function":"minecraft:set_components","components":{"minecraft:item_model":"$(orig)"}}]
