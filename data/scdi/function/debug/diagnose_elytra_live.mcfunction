# tests the REAL entry points used during actual gameplay (nullify_check /
# restore_check - the same functions combat_active.mcfunction and
# restore_check's callers use), not a hand-picked internal function - so
# this gives a definitive answer independent of whether you're actually
# tagged/in combat right now. usage: wear a real elytra, then
# /function scdi:debug/diagnose_elytra_live
# temporarily forces debug_custom_items on for this one run (restored to
# whatever it was after), so nullify_check.mcfunction's own [dbg-armor]
# lines print too - one command now gives the full picture instead of
# needing the menu toggle flipped separately first.
data modify storage scdi:tmp24 was_debug set from storage scdi:config debug_custom_items
data modify storage scdi:config debug_custom_items set value 1b

tellraw @s {"text":"[elytra-live] BEFORE:","color":"yellow"}
tellraw @s [{"text":"[elytra-live] disable_elytra = ","color":"gray"},{"nbt":"disable_elytra","storage":"scdi:config","interpret":false,"color":"yellow"}]
tellraw @s [{"text":"[elytra-live] chest = ","color":"gray"},{"nbt":"equipment.chest","entity":"@s","interpret":false}]

execute if predicate scdi:elytra_armor run tellraw @s {"text":"[elytra-live] elytra_armor predicate: TRUE (real elytra worn)","color":"green"}
execute unless predicate scdi:elytra_armor run tellraw @s {"text":"[elytra-live] elytra_armor predicate: FALSE - not wearing a real elytra, or it's already disguised","color":"red"}
execute if predicate scdi:nulled_armor run tellraw @s {"text":"[elytra-live] nulled_armor predicate: TRUE (already disguised right now)","color":"yellow"}

# the EXACT same combined condition nullify_check.mcfunction's real gate
# uses, tested directly and reported explicitly - rules out any gap between
# each predicate being individually true and the combined "if ... if ...
# unless ..." chain actually passing.
execute if data storage scdi:config {disable_elytra:1b} if predicate scdi:elytra_armor unless predicate scdi:nulled_armor run tellraw @s {"text":"[elytra-live] COMBINED gate (disable_elytra + elytra_armor + not already nulled): PASSES - nullify_armor should run","color":"green"}
execute unless data storage scdi:config {disable_elytra:1b} run tellraw @s {"text":"[elytra-live] COMBINED gate FAILS: disable_elytra is off","color":"red"}
execute if data storage scdi:config {disable_elytra:1b} unless predicate scdi:elytra_armor run tellraw @s {"text":"[elytra-live] COMBINED gate FAILS: elytra_armor predicate false","color":"red"}
execute if data storage scdi:config {disable_elytra:1b} if predicate scdi:elytra_armor if predicate scdi:nulled_armor run tellraw @s {"text":"[elytra-live] COMBINED gate FAILS: nulled_armor predicate is true (thinks it's already disguised)","color":"red"}

tellraw @s {"text":"[elytra-live] STEP 1: function scdi:nullify_check (exact same call combat_active.mcfunction makes every tick you're tagged)","color":"yellow"}
function scdi:nullify_check
tellraw @s [{"text":"[elytra-live] chest after nullify_check = ","color":"gray"},{"nbt":"equipment.chest","entity":"@s","interpret":false}]

tellraw @s {"text":"[elytra-live] STEP 2: function scdi:restore_check (exact same call combat_end.mcfunction/passive-restore make)","color":"yellow"}
function scdi:restore_check
tellraw @s [{"text":"[elytra-live] chest after restore_check = ","color":"gray"},{"nbt":"equipment.chest","entity":"@s","interpret":false}]

tellraw @s {"text":"[elytra-live] DONE - if the chest id never changed to disguise_item in STEP 1, or never changed back to minecraft:elytra in STEP 2, that pinpoints exactly which half is broken.","color":"green"}

data modify storage scdi:config debug_custom_items set from storage scdi:tmp24 was_debug
