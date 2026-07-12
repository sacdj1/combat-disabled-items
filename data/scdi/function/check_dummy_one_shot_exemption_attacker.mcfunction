# called at @s (attacker) from on_attacked_entity.mcfunction, only when
# no_tag_on_one_shot_kill is on and a dummy was hit. unlike the player
# version (check_one_shot_exemption_attacker.mcfunction) no proximity
# guessing is needed - we already know exactly which dummy was hit. only
# exempts a MORTAL dummy's first-ever hit also being the killing blow (the
# same "fight's already over" reasoning as the player version) - an
# invincible dummy cheating death isn't a real kill, the fight continues,
# so hitting one never exempts the attacker this way. the sentinel default
# keeps the final comparison harmless if the conditional read below never
# fires (dummy already hit before, or invincible), instead of comparing
# against a stale leftover value from some earlier, unrelated call.
scoreboard players set $dummy_one_shot_hp scdi_const 999999
execute as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..16,sort=nearest,limit=1] unless score @s scdi_dummy_invincible matches 1.. unless score @s scdi_dummy_hit matches 1.. store result score $dummy_one_shot_hp scdi_const run data get entity @s Health 1
execute store result score $dummy_one_shot_threshold scdi_const run data get storage scdi:config dummy_death_threshold 1
execute if score $dummy_one_shot_hp scdi_const <= $dummy_one_shot_threshold scdi_const run scoreboard players set $should_tag_attacker scdi_const 0
