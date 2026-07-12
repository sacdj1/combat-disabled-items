# called as a dummy within range of the attacker who just hit SOME
# non-player entity (see on_attacked_entity.mcfunction) - handles everything
# that can happen when THIS dummy turns out to be the one that was hit.
#
# debugging aid (debug_hit_messages, default off - see /menu -> Detection):
# confirms this function actually got entered for this specific dummy, and
# what raw Health it saw at entry - used to track down whether a
# suspiciously hard-hitting weapon (e.g. a mace smash attack) somehow
# displaces/kills the dummy before this synchronous reaction even runs.
execute if data storage scdi:config {debug_hit_messages:1b} run tellraw @a [{"text":"[hit-dbg] apply_check_dummy_hit entered for dummy id=","color":"gray"},{"score":{"name":"@s","objective":"scdi_dummy_id"}},{"text":" raw Health=","color":"gray"},{"nbt":"Health","entity":"@s","interpret":false}]
#
# damage-number delta uses scdi_dummy_health_fine (scale 10 - tenths of a
# health point) so small hits under 1 full HP still register as a real
# nonzero popup instead of rounding away to 0. kept separate from
# scdi_health (scale 1) below, which the death-threshold check uses -
# changing one's precision never touches the other.
scoreboard players operation @s scdi_dummy_dmg = @s scdi_dummy_health_fine
execute store result score @s scdi_dummy_health_fine run data get entity @s Health 10
scoreboard players operation @s scdi_dummy_dmg -= @s scdi_dummy_health_fine

# scale 1, not 100 - dummy_death_threshold is in raw HP units (default 2 =
# 2 health), unlike the *100-scaled scdi_health reads elsewhere in this
# pack (check_one_shot.mcfunction, on_hurt_by_player_retag.mcfunction) that
# only ever compare against 0 (scale-invariant). this was a real bug: with
# scale 100, "matches ..2" was checking Health <= 0.02, not Health <= 2 -
# meaning the threshold never actually changed anything from the old
# exact-zero check no matter what you set it to.
execute store result score @s scdi_health run data get entity @s Health 1

# DPS tracking (also in tenths, matching scdi_dummy_dmg): a fresh encounter
# (scdi_dummy_hit unset - same "first hit" signal already used for one-shot
# detection) resets the running total and start time, so DPS reflects THIS
# test run rather than damage from ages ago. reset happens automatically
# again once the dummy heals back to full
# (apply_dummy_regen_heal.mcfunction/menu/dummy_menu_heal.mcfunction clear
# scdi_dummy_hit when that happens). see
# apply_update_dummy_health_display.mcfunction for where DPS is computed
# and shown (it divides back out the *10 scale there).
execute unless score @s scdi_dummy_hit matches 1.. run scoreboard players set @s scdi_dummy_total_dmg 0
execute unless score @s scdi_dummy_hit matches 1.. run scoreboard players operation @s scdi_dummy_encounter_start_tick = $ticks scdi_const
execute if score @s scdi_dummy_dmg matches 1.. run scoreboard players operation @s scdi_dummy_total_dmg += @s scdi_dummy_dmg

# splits scdi_dummy_dmg (tenths) into whole/tenths parts for the "-N.n"
# popup text - computed once here as plain scores rather than something the
# display needs to read live, since a one-off popup's text never changes
# after it spawns.
execute if data storage scdi:config {dummy_damage_numbers:1b} if score @s scdi_dummy_dmg matches 1.. run scoreboard players operation $dummy_dmg_whole scdi_const = @s scdi_dummy_dmg
execute if data storage scdi:config {dummy_damage_numbers:1b} if score @s scdi_dummy_dmg matches 1.. run scoreboard players operation $dummy_dmg_whole scdi_const /= $ten scdi_const
execute if data storage scdi:config {dummy_damage_numbers:1b} if score @s scdi_dummy_dmg matches 1.. run scoreboard players operation $dummy_dmg_tenths scdi_const = @s scdi_dummy_dmg
execute if data storage scdi:config {dummy_damage_numbers:1b} if score @s scdi_dummy_dmg matches 1.. run scoreboard players operation $dummy_dmg_tenths scdi_const %= $ten scdi_const
execute if data storage scdi:config {dummy_damage_numbers:1b} if score @s scdi_dummy_dmg matches 1.. run function scdi:spawn_dummy_damage_display

# one_shot_dmg needs the *10 (tenths) scale to compare directly against
# scdi_dummy_dmg above - "data get ... 10" multiplies the source value by
# 10 as part of the read, same trick scdi_dummy_health_fine uses.
execute store result storage scdi:tmp18 threshold int 1 run data get storage scdi:config dummy_death_threshold 1
execute store result storage scdi:tmp18 one_shot_dmg int 1 run data get storage scdi:config dummy_one_shot_damage 10
function scdi:apply_check_dummy_hit2 with storage scdi:tmp18
