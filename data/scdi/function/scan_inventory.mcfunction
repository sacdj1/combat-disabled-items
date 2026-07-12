# full player inventory is slots 0-35 (0-8 hotbar, 9-35 main storage) -
# covers a nulled item no matter where within your own inventory it gets
# moved to. no real loop construct in mcfunctions, so this is just written out.
# slot_arg is the /item modify slot-range argument for that raw slot number -
# hotbar.0-8 covers raw slots 0-8, inventory.0-26 covers raw slots 9-35 (NOT
# hotbar.9+, which doesn't exist as a valid slot range and silently no-ops).
function scdi:check_hotbar_slot {slot:0,slot_arg:"hotbar.0"}
function scdi:check_hotbar_slot {slot:1,slot_arg:"hotbar.1"}
function scdi:check_hotbar_slot {slot:2,slot_arg:"hotbar.2"}
function scdi:check_hotbar_slot {slot:3,slot_arg:"hotbar.3"}
function scdi:check_hotbar_slot {slot:4,slot_arg:"hotbar.4"}
function scdi:check_hotbar_slot {slot:5,slot_arg:"hotbar.5"}
function scdi:check_hotbar_slot {slot:6,slot_arg:"hotbar.6"}
function scdi:check_hotbar_slot {slot:7,slot_arg:"hotbar.7"}
function scdi:check_hotbar_slot {slot:8,slot_arg:"hotbar.8"}
function scdi:check_hotbar_slot {slot:9,slot_arg:"inventory.0"}
function scdi:check_hotbar_slot {slot:10,slot_arg:"inventory.1"}
function scdi:check_hotbar_slot {slot:11,slot_arg:"inventory.2"}
function scdi:check_hotbar_slot {slot:12,slot_arg:"inventory.3"}
function scdi:check_hotbar_slot {slot:13,slot_arg:"inventory.4"}
function scdi:check_hotbar_slot {slot:14,slot_arg:"inventory.5"}
function scdi:check_hotbar_slot {slot:15,slot_arg:"inventory.6"}
function scdi:check_hotbar_slot {slot:16,slot_arg:"inventory.7"}
function scdi:check_hotbar_slot {slot:17,slot_arg:"inventory.8"}
function scdi:check_hotbar_slot {slot:18,slot_arg:"inventory.9"}
function scdi:check_hotbar_slot {slot:19,slot_arg:"inventory.10"}
function scdi:check_hotbar_slot {slot:20,slot_arg:"inventory.11"}
function scdi:check_hotbar_slot {slot:21,slot_arg:"inventory.12"}
function scdi:check_hotbar_slot {slot:22,slot_arg:"inventory.13"}
function scdi:check_hotbar_slot {slot:23,slot_arg:"inventory.14"}
function scdi:check_hotbar_slot {slot:24,slot_arg:"inventory.15"}
function scdi:check_hotbar_slot {slot:25,slot_arg:"inventory.16"}
function scdi:check_hotbar_slot {slot:26,slot_arg:"inventory.17"}
function scdi:check_hotbar_slot {slot:27,slot_arg:"inventory.18"}
function scdi:check_hotbar_slot {slot:28,slot_arg:"inventory.19"}
function scdi:check_hotbar_slot {slot:29,slot_arg:"inventory.20"}
function scdi:check_hotbar_slot {slot:30,slot_arg:"inventory.21"}
function scdi:check_hotbar_slot {slot:31,slot_arg:"inventory.22"}
function scdi:check_hotbar_slot {slot:32,slot_arg:"inventory.23"}
function scdi:check_hotbar_slot {slot:33,slot_arg:"inventory.24"}
function scdi:check_hotbar_slot {slot:34,slot_arg:"inventory.25"}
function scdi:check_hotbar_slot {slot:35,slot_arg:"inventory.26"}
