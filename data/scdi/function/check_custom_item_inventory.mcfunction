# called with {item:"minecraft:...",enchant:"..."} from check_custom_item_slots.mcfunction -
# checks all 36 inventory slots for this specific custom item, unrolled the same
# way as scan_hotbar.mcfunction/scan_extended_inventory.mcfunction since
# there's no real loop construct. this is gated by the custom item RULE's
# own per-item scan_inventory flag (disguise_targets[i].scan_inventory),
# not the global scan_hotbar/scan_extended_inventory settings - a
# different, independent toggle despite the similar name.
$function scdi:check_custom_item_hotbar_slot {slot:0,slot_arg:"hotbar.0",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:1,slot_arg:"hotbar.1",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:2,slot_arg:"hotbar.2",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:3,slot_arg:"hotbar.3",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:4,slot_arg:"hotbar.4",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:5,slot_arg:"hotbar.5",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:6,slot_arg:"hotbar.6",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:7,slot_arg:"hotbar.7",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:8,slot_arg:"hotbar.8",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:9,slot_arg:"inventory.0",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:10,slot_arg:"inventory.1",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:11,slot_arg:"inventory.2",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:12,slot_arg:"inventory.3",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:13,slot_arg:"inventory.4",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:14,slot_arg:"inventory.5",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:15,slot_arg:"inventory.6",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:16,slot_arg:"inventory.7",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:17,slot_arg:"inventory.8",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:18,slot_arg:"inventory.9",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:19,slot_arg:"inventory.10",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:20,slot_arg:"inventory.11",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:21,slot_arg:"inventory.12",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:22,slot_arg:"inventory.13",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:23,slot_arg:"inventory.14",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:24,slot_arg:"inventory.15",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:25,slot_arg:"inventory.16",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:26,slot_arg:"inventory.17",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:27,slot_arg:"inventory.18",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:28,slot_arg:"inventory.19",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:29,slot_arg:"inventory.20",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:30,slot_arg:"inventory.21",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:31,slot_arg:"inventory.22",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:32,slot_arg:"inventory.23",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:33,slot_arg:"inventory.24",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:34,slot_arg:"inventory.25",item:"$(item)",enchant:"$(enchant)"}
$function scdi:check_custom_item_hotbar_slot {slot:35,slot_arg:"inventory.26",item:"$(item)",enchant:"$(enchant)"}
