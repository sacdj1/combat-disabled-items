# resets EVERY /menu-configurable setting back to its out-of-the-box default,
# including wiping your custom item list (disguise_targets) back to empty.
# does NOT touch per-player runtime state - who's currently tagged, stopwatch
# ids, scdi_team assignments, death tracking are all left alone; this only
# covers the settings exposed through /menu (see apply_reset_config.mcfunction
# for the exact list). usage: /function scdi:reset_config (op only)
execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run function scdi:apply_reset_config
execute if entity @s[level=2..] run tellraw @s {"text":"(✔) All Combat Disabled Items settings reset to default.","color":"green"}
execute if entity @s[level=2..] run function scdi:menu_show
