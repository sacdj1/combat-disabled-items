# hub screen - always call through scdi:menu, which checks permission
# first. every button here (and on every category page) re-checks permission
# too, in case someone's op status changes between the menu being shown and
# clicked. split into category pages instead of one long flat list so it
# doesn't overwhelm - each category's buttons live on their own page and
# refresh back to that same page on click, not this hub.
tellraw @s ["",{"text":"===== ","color":"dark_gray"},{"text":"Combat Disabled Items","color":"red","bold":true},{"text":" =====","color":"dark_gray"}]

tellraw @s [{"text":"> ","color":"dark_gray"},{"text":"Disabled Items","color":"aqua","underlined":true,"bold":true,"click_event":{"action":"run_command","command":"/function scdi:menu/disabled_items"},"hover_event":{"action":"show_text","value":"Which items get disabled (fireworks/wind charges/elytra), full-inventory scanning, and your custom item list."}},{"text":"  - what gets disabled, plus your custom item list","color":"gray"}]

tellraw @s [{"text":"> ","color":"dark_gray"},{"text":"Disguise Appearance","color":"aqua","underlined":true,"bold":true,"click_event":{"action":"run_command","command":"/function scdi:menu/disguise"},"hover_event":{"action":"show_text","value":"What the disguised item looks like: item type, model, name, colors, glint."}},{"text":"  - what the disguise looks like","color":"gray"}]

tellraw @s [{"text":"> ","color":"dark_gray"},{"text":"Detection & Tagging","color":"aqua","underlined":true,"bold":true,"click_event":{"action":"run_command","command":"/function scdi:menu/detection"},"hover_event":{"action":"show_text","value":"PvE mode, proximity tagging, team exemption, tag attacker, retag/death behavior."}},{"text":"  - how/when players get tagged","color":"gray"}]

tellraw @s [{"text":"> ","color":"dark_gray"},{"text":"Timers & Performance","color":"aqua","underlined":true,"bold":true,"click_event":{"action":"run_command","command":"/function scdi:menu/timers"},"hover_event":{"action":"show_text","value":"Combat duration, scan/restore/proximity intervals, passive restore, placement-revert radius."}},{"text":"  - durations and how often checks run","color":"gray"}]

tellraw @s [{"text":"> ","color":"dark_gray"},{"text":"Sounds & Display","color":"aqua","underlined":true,"bold":true,"click_event":{"action":"run_command","command":"/function scdi:menu/sounds_display"},"hover_event":{"action":"show_text","value":"Combat/safe sounds, actionbar text, the big \"In Combat!\" title."}},{"text":"  - sounds, actionbar, title","color":"gray"}]

tellraw @s [{"text":"> ","color":"dark_gray"},{"text":"Misc","color":"aqua","underlined":true,"bold":true,"click_event":{"action":"run_command","command":"/function scdi:menu/misc"},"hover_event":{"action":"show_text","value":"Test dummy spawning/behavior, and which teleport command this pack uses internally."}},{"text":"  - test dummy, teleport command","color":"gray"}]

tellraw @s [{"text":"> ","color":"dark_gray"},{"text":"Reset all settings to default","color":"red","underlined":true,"click_event":{"action":"suggest_command","command":"/function scdi:reset_config"},"hover_event":{"action":"show_text","value":"Prefills the command below - press Enter to actually run it. Resets every setting on every page above (including your custom item list) back to its out-of-the-box default. Does NOT touch who's currently tagged/in combat."}}]

tellraw @s [{"text":"> ","color":"dark_gray"},{"text":"Uninstall (remove ALL world data)","color":"red","bold":true,"underlined":true,"click_event":{"action":"suggest_command","command":"/function scdi:uninstall"},"hover_event":{"action":"show_text","value":"Prefills the command below - press Enter to actually run it. Restores every disguised item for every online player, then removes every scoreboard objective, stored setting, and floating display entity this pack created. Run this BEFORE deleting the datapack from your world's datapacks folder."}}]

tellraw @s {"text":"(op only - buttons re-check permission on click)","color":"dark_gray","italic":true}
