# diagnostic: captures the mainhand item's components, tries removing the
# equippable removal-marker via a plain /data remove, dumps the storage
# copy to confirm whether THAT step worked, then rebuilds on a relay and
# dumps the FINAL item's components too - so we can see exactly which
# stage the marker survives, instead of guessing again.
# usage: hold the broken item in your mainhand, then run this datapack
# function: scdi:debug/diagnose_equippable_removal
data modify storage scdi:tmp28 item set from entity @s SelectedItem.id
data modify storage scdi:tmp28 count set from entity @s SelectedItem.count
data modify storage scdi:tmp28 components set value {}
execute if data entity @s SelectedItem.components run data modify storage scdi:tmp28 components set from entity @s SelectedItem.components
tellraw @s {"text":"[diag] BEFORE removal attempt:","color":"yellow"}
tellraw @s [{"nbt":"components","storage":"scdi:tmp28","interpret":false}]
data remove storage scdi:tmp28 components."!minecraft:equippable"
tellraw @s {"text":"[diag] AFTER 'data remove ...components.\"!minecraft:equippable\"':","color":"yellow"}
tellraw @s [{"nbt":"components","storage":"scdi:tmp28","interpret":false}]
function scdi:debug/apply_diagnose_equippable_removal with storage scdi:tmp28
