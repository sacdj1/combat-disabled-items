# called as+at a dummy - manually drops whatever it currently has equipped
# as real item entities, WITHOUT killing it (reuses the same per-slot drop
# logic apply_drop_dummy_armor.mcfunction uses on an actual death, just
# skips the final "kill @s"). used by both the manual [Drop all items]
# button (menu/dummy_menu_drop_items.mcfunction) and the [Remove]/[Remove
# all] buttons (which drop first, then kill separately).
#
# sets a 1-second pickup cooldown (dummy_pickup_tick.mcfunction) BEFORE
# actually dropping anything, so there's no window where the freshly
# thrown items are visible to the pickup check yet the cooldown hasn't
# taken effect - otherwise a dummy with dummy_pickup_items on would just
# immediately re-equip the exact items it was made to throw away.
scoreboard players operation @s scdi_dummy_pickup_cooldown_until = $ticks scdi_const
scoreboard players add @s scdi_dummy_pickup_cooldown_until 20

# computes the dummy's own facing direction ONCE (shared by all 4 slots
# below, since it doesn't change mid-function) instead of the earlier fixed
# per-slot directions, which looked random rather than "thrown the way it's
# looking". standard datapack trick for turning a rotation into a usable
# vector: spawn a throwaway marker exactly 1 block ahead via caret
# notation (which already accounts for yaw), then the offset from the
# dummy's own position to that marker IS the facing direction - "rotated as
# @s" (not "anchored eyes") so pitch/tilt doesn't send items into the
# ground or sky, just level with wherever it's facing.
execute store result score $throw_x0 scdi_const run data get entity @s Pos[0] 1000
execute store result score $throw_z0 scdi_const run data get entity @s Pos[2] 1000
execute at @s rotated as @s positioned ^ ^ ^1 run summon minecraft:marker ~ ~ ~ {Tags:["scdi_throw_marker"]}
execute as @e[type=minecraft:marker,tag=scdi_throw_marker,limit=1,sort=nearest] store result score $throw_x1 scdi_const run data get entity @s Pos[0] 1000
execute as @e[type=minecraft:marker,tag=scdi_throw_marker,limit=1,sort=nearest] store result score $throw_z1 scdi_const run data get entity @s Pos[2] 1000
kill @e[type=minecraft:marker,tag=scdi_throw_marker]
scoreboard players operation $throw_x1 scdi_const -= $throw_x0 scdi_const
scoreboard players operation $throw_z1 scdi_const -= $throw_z0 scdi_const
execute store result storage scdi:tmp7 dx double 0.00025 run scoreboard players get $throw_x1 scdi_const
execute store result storage scdi:tmp7 dz double 0.00025 run scoreboard players get $throw_z1 scdi_const

function scdi:apply_drop_dummy_armor_slot {slot:"head"}
function scdi:apply_drop_dummy_armor_slot {slot:"chest"}
function scdi:apply_drop_dummy_armor_slot {slot:"legs"}
function scdi:apply_drop_dummy_armor_slot {slot:"feet"}
