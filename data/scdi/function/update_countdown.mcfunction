# called with {slot_arg:"..."} - scdi_item_dur/scdi_elapsed must already be
# current (see get_effective_duration.mcfunction / combat_tick.mcfunction).
# repurposes the disguised stack's count to show seconds remaining until ITS
# OWN duration expires, clamped 1-99 (a stack can't show 0 meaningfully, and
# vanilla's count text caps around 2 digits anyway). the real original count
# lives separately in custom_data.scdi.real_count and is never touched here.
$data modify storage scdi:tmp5 slot_arg set value "$(slot_arg)"
scoreboard players operation @s scdi_item_sec = @s scdi_item_dur
scoreboard players operation @s scdi_item_sec -= @s scdi_elapsed
scoreboard players operation @s scdi_item_sec += $ceil_offset scdi_const
scoreboard players operation @s scdi_item_sec /= $div scdi_const
execute if score @s scdi_item_sec matches ..0 run scoreboard players set @s scdi_item_sec 1
execute if score @s scdi_item_sec matches 100.. run scoreboard players set @s scdi_item_sec 99
execute store result storage scdi:tmp5 sec int 1 run scoreboard players get @s scdi_item_sec
function scdi:apply_countdown_count with storage scdi:tmp5
