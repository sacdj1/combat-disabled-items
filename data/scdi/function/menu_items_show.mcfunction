# draws the custom-items submenu - always call through scdi:menu/items,
# which checks permission first.
tellraw @s ["",{"text":"===== ","color":"dark_gray"},{"text":"Combat Disabled Items","color":"red","bold":true},{"text":" - Custom Items","color":"gold"},{"text":" =====","color":"dark_gray"},{"text":"  "},{"text":"[<- Back]","color":"gray","underlined":true,"click_event":{"action":"run_command","command":"/function scdi:menu/disabled_items"}}]

tellraw @s [{"text":"[+ Add item]","color":"aqua","underlined":true,"bold":true,"click_event":{"action":"suggest_command","command":"/data modify storage scdi:config disguise_targets append value {item:\"minecraft:ender_pearl\",scan_inventory:1b,enchant:\"\"}"},"hover_event":{"action":"show_text","value":"Prefills the command in your chat bar - change the item id and press Enter to add it. No limit on how many you add."}}]

tellraw @s [{"text":"[+ Add item requiring an enchant]","color":"aqua","underlined":true,"click_event":{"action":"suggest_command","command":"/data modify storage scdi:config disguise_targets append value {item:\"minecraft:mace\",scan_inventory:1b,enchant:\"minecraft:lunge\"}"},"hover_event":{"action":"show_text","value":"Only disables it if it also has that specific enchantment (any level) - e.g. only an enchanted mace, not a plain one."}}]

execute unless data storage scdi:config {disguise_targets:[]} run tellraw @s {"text":"Currently disabled:","color":"gray"}
execute if data storage scdi:config {disguise_targets:[]} run tellraw @s {"text":"(none yet - click Add item above)","color":"dark_gray","italic":true}

scoreboard players set $custom_idx scdi_const 0
function scdi:menu_items_list_recursive

tellraw @s [{"text":"< Back to main menu","color":"aqua","underlined":true,"click_event":{"action":"run_command","command":"/function scdi:menu"}}]
tellraw @s {"text":"(op only - buttons re-check permission on click)","color":"dark_gray","italic":true}
