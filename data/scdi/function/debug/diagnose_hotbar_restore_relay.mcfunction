# manually walks through apply_restore_hotbar_slot.mcfunction's relay
# rebuild step by step, dumping the item at each stage, to catch exactly
# where a chestplate/helmet/leggings/boots restored via this path loses
# its wearability even though id/enchantments/etc all look correct in a
# plain /data get. usage: have a genuinely nulled netherite_chestplate
# (orig set, snapshot set, null:1b) as your held/selected item, then run
# /function scdi:debug/diagnose_hotbar_restore_relay
data modify storage scdi:tmp2 orig set value "minecraft:firework_rocket"
execute if data entity @s SelectedItem.components."minecraft:custom_data".scdi.orig run data modify storage scdi:tmp2 orig set from entity @s SelectedItem.components."minecraft:custom_data".scdi.orig
data modify storage scdi:tmp2 count set from entity @s SelectedItem.count
execute if data entity @s SelectedItem.components."minecraft:custom_data".scdi.real_count run data modify storage scdi:tmp2 count set from entity @s SelectedItem.components."minecraft:custom_data".scdi.real_count
data modify storage scdi:tmp2 snapshot set value {}
execute if data entity @s SelectedItem.components."minecraft:custom_data".scdi.snapshot run data modify storage scdi:tmp2 snapshot set from entity @s SelectedItem.components."minecraft:custom_data".scdi.snapshot

tellraw @s [{"text":"[relay-dbg] orig=","color":"gray"},{"nbt":"orig","storage":"scdi:tmp2","interpret":false},{"text":" count=","color":"gray"},{"nbt":"count","storage":"scdi:tmp2","interpret":false}]
tellraw @s [{"text":"[relay-dbg] snapshot=","color":"gray"},{"nbt":"snapshot","storage":"scdi:tmp2","interpret":false}]

execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_diagnose_relay"]}
execute as @e[type=minecraft:armor_stand,tag=scdi_diagnose_relay,limit=1,sort=nearest] run data merge entity @s {equipment:{mainhand:{id:"minecraft:netherite_chestplate",count:1,components:{"minecraft:enchantments":{"minecraft:protection":4}}}}}

tellraw @s {"text":"[relay-dbg] STEP A: relay stand's own weapon.mainhand right after merge","color":"yellow"}
tellraw @s [{"text":"[relay-dbg] equipment.mainhand=","color":"gray"},{"nbt":"equipment.mainhand","entity":"@e[type=minecraft:armor_stand,tag=scdi_diagnose_relay,limit=1,sort=nearest]","interpret":false}]

execute as @e[type=minecraft:armor_stand,tag=scdi_diagnose_relay,limit=1,sort=nearest] store result score $relay_armor scdi_const run attribute @s minecraft:armor get
tellraw @s [{"text":"[relay-dbg] (n/a for stands, just checking it doesn't error) armor=","color":"gray"},{"score":{"name":"$relay_armor","objective":"scdi_const"}}]

tellraw @s {"text":"[relay-dbg] STEP B: item replace onto hotbar.0 FROM the relay's weapon.mainhand","color":"yellow"}
item replace entity @s hotbar.0 from entity @e[type=minecraft:armor_stand,tag=scdi_diagnose_relay,limit=1,sort=nearest] weapon.mainhand
tellraw @s [{"text":"[relay-dbg] hotbar.0 (Inventory slot 0) after replace=","color":"gray"},{"nbt":"Inventory[{Slot:0b}]","entity":"@s","interpret":false}]

kill @e[type=minecraft:armor_stand,tag=scdi_diagnose_relay,limit=1,sort=nearest]

tellraw @s {"text":"[relay-dbg] DONE - now try wearing whatever landed in hotbar slot 0 (drag it to your head slot) and report whether it works. This test used a SYNTHETIC fresh chestplate, not your actual broken one, to rule out pre-existing corruption.","color":"green"}
