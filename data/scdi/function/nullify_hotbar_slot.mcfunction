# called with {slot:N,slot_arg:"...",orig:"..."} once check_hotbar_slot.mcfunction
# confirms it's needed. no need to capture the fireworks component - see
# nullify_mainhand.mcfunction
$data modify storage scdi:tmp slot_arg set value "$(slot_arg)"
$data modify storage scdi:tmp orig set value "$(orig)"
data modify storage scdi:tmp snapshot set value {}
$execute if data entity @s Inventory[{Slot:$(slot)b}].components run data modify storage scdi:tmp snapshot set from entity @s Inventory[{Slot:$(slot)b}].components
$data modify storage scdi:tmp real_count set from entity @s Inventory[{Slot:$(slot)b}].count
data modify storage scdi:tmp item set from storage scdi:config disguise_item
data modify storage scdi:tmp model set from storage scdi:config disguise_model
data modify storage scdi:tmp name set from storage scdi:config disguise_name
data modify storage scdi:tmp name_color set from storage scdi:config disguise_name_color
data modify storage scdi:tmp name_bold set from storage scdi:config disguise_name_bold
data modify storage scdi:tmp name_italic set from storage scdi:config disguise_name_italic
data modify storage scdi:tmp glint set from storage scdi:config disguise_glint
function scdi:apply_nullify_hotbar_slot with storage scdi:tmp
