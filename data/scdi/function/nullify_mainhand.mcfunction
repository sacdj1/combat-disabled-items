# called with {orig:"minecraft:firework_rocket"} or {orig:"minecraft:wind_charge"}
# - orig gets stashed in the disguised item's own custom_data so restore
# knows which real item to reconstruct later, since a gunpowder disguise
# looks the same either way. no need to capture/restore the fireworks
# component by hand: ItemStack.transmuteCopy carries over the item's full
# explicit component patch (confirmed via javap disassembly) onto the new
# item type regardless of what that type is, so the original
# minecraft:fireworks override (if the rocket has one - a crafted rocket with
# real explosions does, a bare test item may not) automatically rides along
# through the gunpowder disguise and reappears the instant it transmutes back.
$data modify storage scdi:tmp orig set value "$(orig)"
data modify storage scdi:tmp snapshot set value {}
execute if data entity @s SelectedItem.components run data modify storage scdi:tmp snapshot set from entity @s SelectedItem.components
# captured now, before any count mutation, so the countdown-via-count display
# (see check_mainhand_duration_tick.mcfunction) has a real original value to
# restore back to later instead of whatever count it was last showing
data modify storage scdi:tmp real_count set from entity @s SelectedItem.count
data modify storage scdi:tmp item set from storage scdi:config disguise_item
data modify storage scdi:tmp model set from storage scdi:config disguise_model
data modify storage scdi:tmp name set from storage scdi:config disguise_name
data modify storage scdi:tmp name_color set from storage scdi:config disguise_name_color
data modify storage scdi:tmp name_bold set from storage scdi:config disguise_name_bold
data modify storage scdi:tmp name_italic set from storage scdi:config disguise_name_italic
data modify storage scdi:tmp glint set from storage scdi:config disguise_glint
function scdi:apply_nullify_mainhand with storage scdi:tmp
