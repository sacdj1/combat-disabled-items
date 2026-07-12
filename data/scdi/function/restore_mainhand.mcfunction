# capture count + the real minecraft:fireworks data (flight duration/
# explosions) off the currently-disguised item before it's replaced. this now
# uses /loot replace instead of /item modify set_item: set_item's
# transmuteCopy carries the ENTIRE old component patch forward (including our
# tracking components), and removing them afterward via "!key":{} still left
# residue that broke stacking with genuine vanilla rockets and caused visual
# glitches. /loot replace instead constructs a BRAND NEW ItemStack from the
# item's own registry prototype - zero patch, nothing to strip - see
# apply_restore_mainhand.mcfunction.
# orig (which real item to reconstruct - firework_rocket or wind_charge) was
# stashed in custom_data by nullify_mainhand.mcfunction, since a gunpowder
# disguise looks the same either way
data modify storage scdi:tmp orig set value "minecraft:firework_rocket"
execute if data entity @s SelectedItem.components."minecraft:custom_data".scdi.orig run data modify storage scdi:tmp orig set from entity @s SelectedItem.components."minecraft:custom_data".scdi.orig
# real_count, not the item's LIVE count - the countdown-via-count display
# (see check_mainhand_duration_tick.mcfunction) overwrites the live count
# every tick to show seconds remaining, so the true original is only
# reliably found in real_count, captured once at nullify time
data modify storage scdi:tmp count set from entity @s SelectedItem.count
execute if data entity @s SelectedItem.components."minecraft:custom_data".scdi.real_count run data modify storage scdi:tmp count set from entity @s SelectedItem.components."minecraft:custom_data".scdi.real_count
data modify storage scdi:tmp fireworks set value {"flight_duration":1,"explosions":[]}
execute if data entity @s SelectedItem.components."minecraft:fireworks" run data modify storage scdi:tmp fireworks set from entity @s SelectedItem.components."minecraft:fireworks"
# only actually needed for the "anything else" (custom item) branch below -
# see apply_restore_mainhand.mcfunction
data modify storage scdi:tmp snapshot set value {}
execute if data entity @s SelectedItem.components."minecraft:custom_data".scdi.snapshot run data modify storage scdi:tmp snapshot set from entity @s SelectedItem.components."minecraft:custom_data".scdi.snapshot
function scdi:apply_restore_mainhand with storage scdi:tmp
