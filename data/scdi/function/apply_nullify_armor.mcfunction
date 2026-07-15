# rebuilt AGAIN - the previous "data modify entity @s equipment.chest set
# value {...}" direct-write approach was copied from
# apply_dummy_pickup_item.mcfunction, which runs on the DUMMY (a plain
# minecraft:mannequin), not a real player - Mojang's anti-dupe restriction
# on /data modify entity <player> touching inventory/equipment (since
# 1.17, MC-123307) is player-specific. Mannequins aren't players, so that
# exact same command genuinely works there - it just silently did nothing
# here despite looking identical to the dummy's own working code, and
# with no error to reveal why.
#
# switched to the armor-stand relay technique (TEST G in
# debug/diagnose_write_methods.mcfunction, confirmed elsewhere in this
# world via the wolf_sit/SPE datapack's own mainhand relay) - give a
# throwaway armor stand the disguise item via a normal entity data merge
# (armor stands aren't players either, so THIS write works fine), then
# /item replace the player's slot FROM the stand. That's a genuinely
# different code path from /data modify or /item modify, not subject to
# the same player-specific lock.
#
# STILL wasn't enough on its own - debug/diagnose_armor_stand_relay2.mcfunction
# showed the merge onto the stand succeeds even with the FULL real payload,
# but the item replace onto the PLAYER's armor.chest slot silently did
# nothing, while the same relay with an actual minecraft:diamond_chestplate
# worked fine (debug/diagnose_armor_stand_relay.mcfunction). the difference:
# disguise_item is normally something deliberately non-armor (a stick,
# gunpowder, etc) with no minecraft:equippable component, and /item replace
# onto an armor slot silently refuses an item that isn't equippable there -
# confirmed via debug/diagnose_equippable_test.mcfunction. adding
# minecraft:equippable explicitly (independent of what disguise_item/model
# actually is - item_model already overrides the visual look regardless)
# makes the write legal again.
#
# minecraft:equippable alone still wasn't the full fix - with just
# {"slot":"chest"} and no asset_id, the disguised item wrote successfully
# but rendered as literally nothing on the wearer's body (confirmed via
# Minecraft's own docs: an equippable item with no asset_id "does not
# render" outside the head slot). asset_id is a SEPARATE visual reference
# from item_model - it points at an equipment asset
# (assets/<ns>/equipment/<id>.json), not an arbitrary item id, so it can't
# just reuse $(model). disguise_armor_model (default "minecraft:leather")
# is the dedicated config for this - see load.mcfunction/menu -> Disguise.
#
# dyed_color is set once here to a fixed red tint (16711680) as the
# baseline - see apply_disguise_armor_flash_particle_slot.mcfunction for
# the particle-based ongoing flash (always on, silent) and
# apply_disguise_armor_flash_recolor_slot.mcfunction for the OPTIONAL
# additional armor-repaint-on-flash (disguise_armor_recolor, off by
# default - every attempt to make that silent failed, so it's an
# accepted-tradeoff opt-in, not the default). equip_sound is set to
# disguise_armor_equip_sound (default a soft note, not the harsh default
# armor clink) so that at minimum the ONE guaranteed sound - this initial
# swap - is as unobtrusive as possible, whether or not recolor is on.
#
# Curse of Binding was tried here briefly to block manual unequip mid-combat,
# but removed again - the restore path needs to correctly revert the real
# item's appearance (both inventory icon and worn model) regardless of
# whether it gets moved to inventory first, rather than just preventing
# that from happening. see apply_restore_hotbar_slot.mcfunction for the
# loose-in-inventory restore path this depends on.
execute at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,NoGravity:1b,Tags:["scdi_armor_relay"]}
$execute as @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest] run data merge entity @s {equipment:{chest:{id:"$(item)",count:1,components:{"minecraft:custom_data":{"scdi":{"null":true,"orig":"$(orig)","snapshot":$(snapshot),"real_count":$(real_count)}},"minecraft:item_model":"$(model)","minecraft:custom_name":{"text":"$(name)","color":"$(name_color)","bold":$(name_bold),"italic":$(name_italic)},"minecraft:enchantment_glint_override":$(glint),"minecraft:dyed_color":16711680,"minecraft:equippable":{"slot":"chest","asset_id":"$(armor_model)","equip_sound":"$(armor_sound)"}}}}}
item replace entity @s armor.chest from entity @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest] armor.chest
kill @e[type=minecraft:armor_stand,tag=scdi_armor_relay,limit=1,sort=nearest]

execute if data storage scdi:config {debug_custom_items:1b} run tellraw @s [{"text":"[elytra] apply_nullify_armor done - chest now = ","color":"gray"},{"nbt":"equipment.chest.id","entity":"@s","interpret":false}]

function scdi:check_armor_warning
