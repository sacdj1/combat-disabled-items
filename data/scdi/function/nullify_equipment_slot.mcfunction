# called with {equip_key:"head/chest/legs/feet",slot_arg:"equipment.head/...",orig:"minecraft:..."}
# once check_custom_item_equipment_slot(.mcfunction) confirms it's needed.
# reuses apply_nullify_hotbar_slot for the actual swap since /item modify's
# slot names (equipment.head etc) resolve through the entity's live equipment
# accessors regardless of storage layout - only the snapshot-capture NBT read
# needed the equipment.<key> path fix.
$data modify storage scdi:tmp slot_arg set value "$(slot_arg)"
$data modify storage scdi:tmp orig set value "$(orig)"
data modify storage scdi:tmp snapshot set value {}
$execute if data entity @s equipment.$(equip_key).components run data modify storage scdi:tmp snapshot set from entity @s equipment.$(equip_key).components
$data modify storage scdi:tmp real_count set from entity @s equipment.$(equip_key).count
data modify storage scdi:tmp item set from storage scdi:config disguise_item
data modify storage scdi:tmp model set from storage scdi:config disguise_model
data modify storage scdi:tmp name set from storage scdi:config disguise_name
data modify storage scdi:tmp name_color set from storage scdi:config disguise_name_color
data modify storage scdi:tmp name_bold set from storage scdi:config disguise_name_bold
data modify storage scdi:tmp name_italic set from storage scdi:config disguise_name_italic
data modify storage scdi:tmp glint set from storage scdi:config disguise_glint
function scdi:apply_nullify_hotbar_slot with storage scdi:tmp
