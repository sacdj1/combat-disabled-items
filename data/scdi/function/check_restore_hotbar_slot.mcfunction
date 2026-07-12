# called with {slot:N,slot_arg:"..."} - only proceed if that slot holds a nulled item
$execute if data entity @s Inventory[{Slot:$(slot)b,components:{"minecraft:custom_data":{scdi:{null:1b}}}}] run function scdi:restore_hotbar_slot {slot:$(slot),slot_arg:"$(slot_arg)"}
