# simulates "a disguised elytra got moved out of the armor slot into a
# regular inventory slot" without needing a full real combat/move cycle -
# puts a nulled-elytra-shaped item directly into inventory slot 0 (via the
# same nullify_hotbar_slot.mcfunction machinery every other nulled hotbar
# item already uses, just with orig=elytra instead of firework_rocket/
# wind_charge), then runs the exact same restore scan restore_check.mcfunction
# uses, to see whether check_restore_hotbar_slot's generic fallback branch
# actually finds and fixes it. usage: have an EMPTY inventory.0 slot (first
# slot below hotbar), then /function scdi:debug/diagnose_inventory_restore
item replace entity @s inventory.0 with minecraft:elytra

tellraw @s {"text":"[inv-restore] STEP 1: nullify_hotbar_slot with orig=elytra, simulating a disguised elytra sitting in inventory.0","color":"yellow"}
function scdi:nullify_hotbar_slot {slot:9,slot_arg:"inventory.0",orig:"minecraft:elytra"}
tellraw @s [{"text":"[inv-restore] inventory.0 id after nullify = ","color":"gray"},{"nbt":"Inventory[{Slot:9b}].id","entity":"@s","interpret":false}]
tellraw @s [{"text":"[inv-restore] inventory.0 custom_data after nullify = ","color":"gray"},{"nbt":"Inventory[{Slot:9b}].components.\"minecraft:custom_data\"","entity":"@s","interpret":false}]

tellraw @s {"text":"[inv-restore] STEP 2: check_restore_hotbar_slot (exact same call restore_inventory.mcfunction makes for this slot)","color":"yellow"}
function scdi:check_restore_hotbar_slot {slot:9,slot_arg:"inventory.0"}
tellraw @s [{"text":"[inv-restore] inventory.0 id after restore = ","color":"gray"},{"nbt":"Inventory[{Slot:9b}].id","entity":"@s","interpret":false}]

tellraw @s {"text":"[inv-restore] DONE - if STEP 2's id is back to minecraft:elytra, the generic inventory-slot restore path works fine and the real-world bug is elsewhere (e.g. scan_inventory being off, or restore_check never actually running). If it's still the disguise item, the generic fallback branch itself is broken.","color":"green"}
