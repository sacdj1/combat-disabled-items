# removes everything this datapack has added to the world - scoreboard
# objectives, stored config, the below_name display slot (if we're the ones
# using it), floating timer-display entities, and (best effort) each
# player's personal stopwatch - restoring every currently-disguised item for
# every online player first, so nothing is left stuck disguised. run this
# BEFORE deleting the datapack from your world's datapacks folder (this
# function can't remove itself, and can't touch offline players' inventories
# - see apply_uninstall.mcfunction). usage: /function scdi:uninstall (op only)
execute unless entity @s[level=2..] run tellraw @s {"text":"You need to be an operator to use this.","color":"red"}
execute if entity @s[level=2..] run function scdi:apply_uninstall
