# decisive test: checks BOTH write methods (/item modify vs /data modify)
# on BOTH slot families (weapon.mainhand/SelectedItem vs armor.chest/
# equipment.chest) in one pass, on a REAL PLAYER - tells us whether the
# problem is armor-specific, or whether writing ANY equipped item via
# command is broken for players in this environment (mainhand disguise for
# firework rockets/wind charges has never actually been directly confirmed
# working this session - only assumed from lack of complaints).
# usage: hold ANY item in mainhand AND wear ANY chestplate, then
# /function scdi:debug/diagnose_write_methods
tellraw @s [{"text":"[write-test] mainhand before = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s","interpret":false}]
tellraw @s [{"text":"[write-test] chest before = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]

tellraw @s {"text":"[write-test] TEST A: item modify entity @s weapon.mainhand set_item barrier","color":"yellow"}
item modify entity @s weapon.mainhand {"function":"minecraft:set_item","item":"minecraft:barrier"}
tellraw @s [{"text":"[write-test] mainhand = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s","interpret":false}]

tellraw @s {"text":"[write-test] TEST B: data modify entity @s SelectedItem set value {...}","color":"yellow"}
data modify entity @s SelectedItem set value {id:"minecraft:diamond_sword",count:1}
tellraw @s [{"text":"[write-test] mainhand = ","color":"gray"},{"nbt":"SelectedItem.id","entity":"@s","interpret":false}]

tellraw @s {"text":"[write-test] TEST C: item modify entity @s armor.chest set_item barrier","color":"yellow"}
item modify entity @s armor.chest {"function":"minecraft:set_item","item":"minecraft:barrier"}
tellraw @s [{"text":"[write-test] chest = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]

tellraw @s {"text":"[write-test] TEST D: data modify entity @s equipment.chest set value {...}","color":"yellow"}
data modify entity @s equipment.chest set value {id:"minecraft:golden_chestplate",count:1}
tellraw @s [{"text":"[write-test] chest = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]

tellraw @s {"text":"[write-test] TEST E: legacy Inventory[Slot:103b] (old pre-1.9 armor storage - chestplate slot). worth trying since a mod protecting the modern 'equipment' compound specifically might not also guard this.","color":"yellow"}
data modify entity @s Inventory[{Slot:103b}] set value {Slot:103b,id:"minecraft:netherite_chestplate",count:1}
tellraw @s [{"text":"[write-test] chest (via equipment.chest read) = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
tellraw @s [{"text":"[write-test] Inventory[Slot:103b] id = ","color":"gray"},{"nbt":"Inventory[{Slot:103b}].id","entity":"@s","interpret":false}]

tellraw @s {"text":"[write-test] TEST F: pure REMOVAL (unequip, no replacement) - data remove entity @s equipment.chest. a different operation from A-E: some equipment-guarding mods block giving a player a new item more aggressively than just taking one away.","color":"yellow"}
data remove entity @s equipment.chest
tellraw @s [{"text":"[write-test] chest = ","color":"gray"},{"nbt":"equipment.chest","entity":"@s","interpret":false}]

tellraw @s {"text":"[write-test] TEST G: item replace ... from entity (via a temp armor stand relay) - a genuinely different command from A-F, confirmed working for weapon.mainhand elsewhere in this world's own installed datapacks (wolf_sit's bundled SPE library, fix_hand.mcfunction).","color":"yellow"}
summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_writetest_stand"]}
execute as @e[type=minecraft:armor_stand,tag=scdi_writetest_stand,limit=1,sort=nearest] run data merge entity @s {equipment:{chest:{id:"minecraft:diamond_chestplate",count:1}}}
item replace entity @s armor.chest from entity @e[type=minecraft:armor_stand,tag=scdi_writetest_stand,limit=1,sort=nearest] armor.chest
kill @e[type=minecraft:armor_stand,tag=scdi_writetest_stand]
tellraw @s [{"text":"[write-test] chest = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]

tellraw @s {"text":"[write-test] DONE - whichever tests (A/B/C/D/E/F/G) actually changed the value (TEST F: chest should show nothing/empty if removal worked; TEST G: chest should show diamond_chestplate) tell us definitively which write method(s), if any, work on a real player's armor in this environment.","color":"green"}
