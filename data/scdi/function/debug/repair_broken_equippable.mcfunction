# repairs an item broken by an earlier version of apply_restore_hotbar_slot.mcfunction,
# which negated "!minecraft:equippable" thinking it would clear the
# disguise's override and fall back to the item's own type default -
# instead it permanently strips the component, masking the type default
# too, making the item unwearable forever (id/enchantments/etc. all still
# correct, just missing equippable entirely). rebuilds the item fresh on a
# relay entity from ONLY its id/count/components (minus equippable), same
# technique apply_restore_armor.mcfunction always used - a component never
# explicitly included in a fresh merge correctly falls back to the item's
# own type default, unlike negating it after the fact.
# usage: hold the broken item in your mainhand, then run this datapack
# function: scdi:debug/repair_broken_equippable
data modify storage scdi:tmp27 item set from entity @s SelectedItem.id
data modify storage scdi:tmp27 count set from entity @s SelectedItem.count
data modify storage scdi:tmp27 components set value {}
# copying the WHOLE components compound and trying to subtract the bad
# key twice already failed - the "removed equippable" marker's actual
# stored representation isn't reliably addressable by the key name the
# debug dump displayed it as (that's a human-readable rendering, not
# necessarily a literal NBT path). sidesteps the whole question by never
# touching the source's raw components compound at all - cherry-picks only
# the specific legitimate sub-paths we actually want onto a fresh compound.
# add more "execute if data ... run data modify ..." lines here (matching
# this same pattern) for any other real data your specific item had -
# trim/custom_name/damage/etc - if it still doesn't render armor-value
# stats correctly after this.
execute if data entity @s SelectedItem.components."minecraft:enchantments" run data modify storage scdi:tmp27 components."minecraft:enchantments" set from entity @s SelectedItem.components."minecraft:enchantments"
function scdi:debug/apply_repair_broken_equippable with storage scdi:tmp27
