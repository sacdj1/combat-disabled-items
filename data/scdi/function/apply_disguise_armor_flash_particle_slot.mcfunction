# called as+at @s = the tagged player, with {equip_key,y,r,g,b} - only
# spawns anything if that slot currently holds a disguised (nulled) item,
# same predicate check_restore_equipment_slot.mcfunction uses. dust
# particles never touch any entity's NBT, so unlike every other write in
# this pack there's no equip-sound/anti-dupe concern here at all - this is
# purely visual. y is a rough body-height offset for that slot (head/
# chest/legs/feet), not anatomically precise, just close enough to read as
# "coming from that piece of armor".
$execute if data entity @s equipment.$(equip_key){components:{"minecraft:custom_data":{scdi:{null:1b}}}} run particle minecraft:dust{color:[$(r),$(g),$(b)],scale:0.5} ~ ~$(y) ~ 0.15 0.08 0.15 0 6
