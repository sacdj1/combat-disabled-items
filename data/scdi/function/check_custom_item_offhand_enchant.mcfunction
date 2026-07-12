# called with {item:"minecraft:...",enchant:"minecraft:..."} - only ever
# invoked when the caller has already confirmed enchant is non-empty. see
# check_custom_item_mainhand_enchant.mcfunction for why that matters.
$execute if data entity @s equipment.offhand{id:"$(item)"} if data entity @s equipment.offhand.components."minecraft:enchantments"."$(enchant)" unless predicate scdi:nulled_offhand run function scdi:nullify_offhand {orig:"$(item)"}
