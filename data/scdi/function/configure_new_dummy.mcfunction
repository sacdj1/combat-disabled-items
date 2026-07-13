# called immediately as the freshly-summoned dummy (execute ... at @s
# summon minecraft:mannequin run function ...) from dummy_trigger.mcfunction/
# menu/spawn_dummy_now.mcfunction - no proximity guessing needed for which
# entity is the new one. the summon call itself must stay bare (entity id
# only, no explicit position/NBT) - this game version's "summon ... run
# function ..." shorthand fatally fails to parse ("Incorrect argument for
# command") the instant you add inline position or NBT after the entity id,
# confirmed via the server log's function-load errors. every other spawned
# entity in this pack (text_display displays) already followed this rule by
# accident, relying on ambient position + a follow-up "data merge" for NBT -
# this just applies the same rule to the dummy itself, which previously
# tried to pass both directly in the summon command and broke.
#
# no NoAI:1b - deliberately left off. NoGravity is its own toggle instead
# (dummy_no_gravity, default off - falls normally) since data merge can't
# conditionally include a key in one command.
data merge entity @s {profile:{name:"TestDummy"},Tags:["scdi_dummy"]}
execute if data storage scdi:config {dummy_no_gravity:1b} run data merge entity @s {NoGravity:1b}
execute unless data storage scdi:config {dummy_no_gravity:1b} run data merge entity @s {NoGravity:0b}
scoreboard players add $next_dummy_id scdi_const 1
scoreboard players operation @s scdi_dummy_id = $next_dummy_id scdi_const
execute if data storage scdi:config {dummy_immobile:1b} run attribute @s minecraft:knockback_resistance base set 1.0
execute if data storage scdi:config {dummy_show_health:1b} run function scdi:spawn_dummy_health_display

# a much larger health pool than a real player's 20 (dummy_max_health,
# default 1000) - every dummy gets this now, not just invincible-toggled
# ones, so it takes a real sustained beating before it dies instead of
# needing to hit literal 0 of a real 20. sets the attribute then heals
# straight to it - changing max_health alone doesn't touch current Health.
# reads dummy_max_health straight out of scdi:config via macro - this
# whole function must therefore be invoked with "with storage scdi:config"
# (see dummy_trigger.mcfunction/menu/spawn_dummy_now.mcfunction) - a macro
# line with no matching "with" at the call site makes the ENTIRE function
# silently fail to run, not just that one line (confirmed root cause of
# dummies not spawning at all, once, earlier in this pack's history).
$attribute @s minecraft:max_health base set $(dummy_max_health)
execute store result entity @s Health float 1 run attribute @s minecraft:max_health get

# a mortal dummy's REAL death gate is a separate simulated player-sized
# health pool (scdi_dummy_sim_hp, tenths scale), not the big buffer above -
# see load.mcfunction's dummy_one_shot_damage comment and
# apply_check_dummy_hit2.mcfunction for why. starts full.
execute store result score @s scdi_dummy_sim_hp run data get storage scdi:config dummy_one_shot_damage 10

# initializes scdi_health/scdi_dummy_health_fine to the dummy's actual full
# health, so the first real hit's damage-number computation
# (apply_check_dummy_hit.mcfunction) has a real baseline to subtract from
# instead of an unset score.
execute store result score @s scdi_health run data get entity @s Health 1
execute store result score @s scdi_dummy_health_fine run data get entity @s Health 10
