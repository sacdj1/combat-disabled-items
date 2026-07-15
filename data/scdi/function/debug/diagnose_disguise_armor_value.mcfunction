# live snapshot of real generic.armor/armor_toughness plus which armor
# slots are currently disguised (scdi:null custom_data) - no synthetic
# swap, just reports whatever's actually equipped right now. run this
# once BEFORE getting hit (real netherite equipped) and again mid-combat
# right after getting hit (armor disguised via the real custom-item path,
# not a synthetic test item), to compare real numbers from an actual
# fight instead of a lab-only stick test.
# usage: /function scdi:debug/diagnose_disguise_armor_value
execute store result storage scdi:tmp25 armor float 100 run attribute @s minecraft:armor get
execute store result storage scdi:tmp25 toughness float 100 run attribute @s minecraft:armor_toughness get
tellraw @s [{"text":"[armor-val] armor(x100)=","color":"gray"},{"nbt":"armor","storage":"scdi:tmp25","interpret":false},{"text":" toughness(x100)=","color":"gray"},{"nbt":"toughness","storage":"scdi:tmp25","interpret":false}]
tellraw @s [{"text":"[armor-val] head = ","color":"gray"},{"nbt":"equipment.head.id","entity":"@s","interpret":false},{"text":" disguised=","color":"gray"},{"nbt":"equipment.head.components.\"minecraft:custom_data\".scdi.null","entity":"@s","interpret":false}]
tellraw @s [{"text":"[armor-val] chest = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false},{"text":" disguised=","color":"gray"},{"nbt":"equipment.chest.components.\"minecraft:custom_data\".scdi.null","entity":"@s","interpret":false}]
tellraw @s [{"text":"[armor-val] legs = ","color":"gray"},{"nbt":"equipment.legs.id","entity":"@s","interpret":false},{"text":" disguised=","color":"gray"},{"nbt":"equipment.legs.components.\"minecraft:custom_data\".scdi.null","entity":"@s","interpret":false}]
tellraw @s [{"text":"[armor-val] feet = ","color":"gray"},{"nbt":"equipment.feet.id","entity":"@s","interpret":false},{"text":" disguised=","color":"gray"},{"nbt":"equipment.feet.components.\"minecraft:custom_data\".scdi.null","entity":"@s","interpret":false}]
