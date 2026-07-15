# rebuilt AGAIN alongside apply_nullify_armor.mcfunction - see that file's
# header for why the previous "data modify entity @s equipment.chest set
# value {...}" direct write silently did nothing on a real player (that
# technique only actually works on non-player entities like the dummy,
# where it was copied from). same armor-stand relay fix here: reconstruct
# the real elytra (real captured components - enchantments/trim/
# durability/name, whatever was really on it - merged back in) onto a
# throwaway armor stand via a normal entity data merge, then /item replace
# the player's slot FROM the stand.
# clear the slot to empty FIRST, as its own step, before setting the real
# item back - an atomic occupied-slot-to-occupied-slot replace doesn't
# always make the client refetch the worn equipment model (a Mojang
# rendering cache quirk with custom equippable/asset_id items), leaving the
# disguise's model visually stuck even though the real item is correctly
# back server-side. an empty-then-filled cycle forces a genuine refresh.
item replace entity @s armor.chest with air
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_armor_relay"]}
$execute as @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest] run data merge entity @s {equipment:{chest:{id:"minecraft:elytra",count:$(count),components:$(snapshot)}}}
item replace entity @s armor.chest from entity @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest] armor.chest
kill @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest]

execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s [{"text":"[elytra] apply_restore_armor done - chest now = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]
