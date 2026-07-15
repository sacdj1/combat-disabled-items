# hotbar only - raw slots 0-8. split out from the old combined
# scan_inventory.mcfunction so hotbar coverage can stay on independently of
# the rest of the backpack (see scan_extended_inventory.mcfunction) - the
# hotbar is where actively-used items (including whatever just got swapped
# out of an armor slot) are far more likely to end up mid-fight, so it's
# useful to be able to keep this on for correctness while turning the
# other one off to isolate its performance cost. slot_arg is the /item
# modify slot-range argument for that raw slot number - hotbar.0-8 covers
# raw slots 0-8.
function scdi:check_hotbar_slot {slot:0,slot_arg:"hotbar.0"}
function scdi:check_hotbar_slot {slot:1,slot_arg:"hotbar.1"}
function scdi:check_hotbar_slot {slot:2,slot_arg:"hotbar.2"}
function scdi:check_hotbar_slot {slot:3,slot_arg:"hotbar.3"}
function scdi:check_hotbar_slot {slot:4,slot_arg:"hotbar.4"}
function scdi:check_hotbar_slot {slot:5,slot_arg:"hotbar.5"}
function scdi:check_hotbar_slot {slot:6,slot_arg:"hotbar.6"}
function scdi:check_hotbar_slot {slot:7,slot_arg:"hotbar.7"}
function scdi:check_hotbar_slot {slot:8,slot_arg:"hotbar.8"}
