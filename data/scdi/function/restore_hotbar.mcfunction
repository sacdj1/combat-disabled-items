# hotbar only - raw slots 0-8. split out from the old combined
# restore_inventory.mcfunction - see scan_hotbar.mcfunction for why hotbar
# and the rest of the backpack are independently toggleable. detects and
# restores ANY disguised item found here (custom_data.scdi.null:1b),
# regardless of how it got disguised or what type it originally was - see
# check_restore_hotbar_slot.mcfunction.
function scdi:check_restore_hotbar_slot {slot:0,slot_arg:"hotbar.0"}
function scdi:check_restore_hotbar_slot {slot:1,slot_arg:"hotbar.1"}
function scdi:check_restore_hotbar_slot {slot:2,slot_arg:"hotbar.2"}
function scdi:check_restore_hotbar_slot {slot:3,slot_arg:"hotbar.3"}
function scdi:check_restore_hotbar_slot {slot:4,slot_arg:"hotbar.4"}
function scdi:check_restore_hotbar_slot {slot:5,slot_arg:"hotbar.5"}
function scdi:check_restore_hotbar_slot {slot:6,slot_arg:"hotbar.6"}
function scdi:check_restore_hotbar_slot {slot:7,slot_arg:"hotbar.7"}
function scdi:check_restore_hotbar_slot {slot:8,slot_arg:"hotbar.8"}
