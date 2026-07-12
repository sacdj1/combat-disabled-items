# called with {item:"minecraft:...",enchant:"minecraft:..."} - only ever
# invoked when the caller has already confirmed enchant is non-empty via a
# plain (non-macro) condition. this matters: substituting an empty $(enchant)
# directly into an NBT path segment (.""）produces invalid syntax that silently
# kills the WHOLE calling function's macro resolution, not just this line -
# that was the actual bug behind custom items with a blank enchant filter
# never getting disabled at all. keeping this check isolated in its own
# function guarantees $(enchant) is always non-empty by the time it's used
# as a path segment here.
$execute if data entity @s SelectedItem{id:"$(item)"} if data entity @s SelectedItem.components."minecraft:enchantments"."$(enchant)" unless predicate scdi:nulled_mainhand run function scdi:nullify_mainhand {orig:"$(item)"}
