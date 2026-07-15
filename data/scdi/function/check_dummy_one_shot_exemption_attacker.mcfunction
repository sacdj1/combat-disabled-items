# called at @s (attacker) from on_attacked_entity.mcfunction, only when
# no_tag_on_one_shot_kill is on and a dummy was hit. unlike the player
# version (check_one_shot_exemption_attacker.mcfunction) no proximity
# guessing is needed - we already know exactly which dummy was hit. only
# exempts a MORTAL dummy's first-ever hit also being the killing blow (the
# same "fight's already over" reasoning as the player version) - an
# invincible dummy cheating death isn't a real kill, the fight continues,
# so hitting one never exempts the attacker this way.
#
# runs BEFORE apply_check_dummy_hit.mcfunction (which does the real,
# authoritative lethal check against scdi_dummy_sim_hp - see
# load.mcfunction's dummy_one_shot_damage comment), so it can't just read
# that result directly - it has to predict it. raw entity Health at this
# point already reflects THIS hit's damage (advancement rewards fire as a
# reaction to damage already applied), but scdi_dummy_sim_hp/
# scdi_dummy_health_fine still hold their PRE-hit values, so the delta
# between the fresh Health read and the still-stale cached health_fine
# gives this hit's damage - the same trick apply_check_dummy_hit.mcfunction
# itself uses, just into scratch scores here so it doesn't disturb that
# function's own identical computation moments later. the sentinel default
# keeps the final comparison harmless if the conditional read below never
# fires (dummy already hit before, or invincible), instead of comparing
# against a stale leftover value from some earlier, unrelated call.
scoreboard players set $dummy_one_shot_sim_after scdi_const 999999
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..16,sort=nearest,limit=1] unless score @s scdi_dummy_invincible matches 1.. unless score @s scdi_dummy_hit matches 1.. store result score $dummy_one_shot_fresh_health scdi_const run data get entity @s Health 10
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..16,sort=nearest,limit=1] unless score @s scdi_dummy_invincible matches 1.. unless score @s scdi_dummy_hit matches 1.. run scoreboard players operation $dummy_one_shot_dmg scdi_const = @s scdi_dummy_health_fine
scoreboard players operation $dummy_one_shot_dmg scdi_const -= $dummy_one_shot_fresh_health scdi_const
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..16,sort=nearest,limit=1] unless score @s scdi_dummy_invincible matches 1.. unless score @s scdi_dummy_hit matches 1.. run scoreboard players operation $dummy_one_shot_sim_after scdi_const = @s scdi_dummy_sim_hp
scoreboard players operation $dummy_one_shot_sim_after scdi_const -= $dummy_one_shot_dmg scdi_const
execute if score $dummy_one_shot_sim_after scdi_const matches ..0 run scoreboard players set $should_tag_attacker scdi_const 0

# debugging aid (debug_hit_messages, default off - see /menu -> Detection)
execute if data storage scdi:config {debug_hit_messages:1b} as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..16,sort=nearest,limit=1] run tellraw @a [{"text":"[oneshot-dbg] invincible=","color":"gray"},{"score":{"name":"@s","objective":"scdi_dummy_invincible"}},{"text":" scdi_dummy_hit=","color":"gray"},{"score":{"name":"@s","objective":"scdi_dummy_hit"}},{"text":" sim_hp(pre)=","color":"gray"},{"score":{"name":"@s","objective":"scdi_dummy_sim_hp"}}]
execute if data storage scdi:config {debug_hit_messages:1b} run tellraw @a [{"text":"[oneshot-dbg] fresh_health=","color":"gray"},{"score":{"name":"$dummy_one_shot_fresh_health","objective":"scdi_const"}},{"text":" dmg=","color":"gray"},{"score":{"name":"$dummy_one_shot_dmg","objective":"scdi_const"}},{"text":" sim_after=","color":"gray"},{"score":{"name":"$dummy_one_shot_sim_after","objective":"scdi_const"}},{"text":" should_tag_attacker=","color":"gray"},{"score":{"name":"$should_tag_attacker","objective":"scdi_const"}}]
