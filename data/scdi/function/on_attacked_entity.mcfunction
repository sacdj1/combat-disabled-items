# fires as the ATTACKER whenever they deal damage to a non-player entity
# (mob, animal, test dummy). only actually tags them for a genuine mob if
# pve_mode is enabled (default: off) - covers the other PvE direction from
# on_hurt_by_anything.mcfunction, which handles a mob hurting the player;
# this one handles the player hurting a mob.
#
# debugging aid (debug_hit_messages, default off - see /menu -> Detection):
# prints whether this function fired and lists every entity within 16
# blocks. broadcasts to @a so it shows up in whoever's log you're reading,
# not just whoever's local client received it.
execute if data storage scdi:config {debug_hit_messages:1b} at @s run tellraw @a [{"text":"[hit-dbg] on_attacked_entity fired - attacker=","color":"gray"},{"selector":"@s"},{"text":" nearby entities (any type, distance..16): ","color":"gray"}]
execute if data storage scdi:config {debug_hit_messages:1b} at @s as @e[distance=..16] run tellraw @a [{"text":"[hit-dbg]   nearby: ","color":"gray"},{"selector":"@s"},{"text":" type=","color":"gray"},{"nbt":"id","entity":"@s","interpret":false}]

execute if data storage scdi:config {pve_mode:1b} run function scdi:on_hurt_by_player_tag_only

# a test dummy simulates a real player for tagging purposes, regardless of
# pve_mode - hitting one tags the attacker exactly like tag_attacker does
# for hitting a real player, since that's the whole point of a test dummy
# (pve_mode is meant for genuine mobs, not this). distance=..16 (not the
# tighter ..6 used to feel like this used to be) covers melee, a thrown/shot
# ranged hit, AND a mace smash attack - a smash attack lands while the
# ATTACKER is still falling from height, so their position at the exact
# moment this reaction fires can genuinely be several blocks above the
# target, not adjacent to it like a normal swing; a smash-attack one-shot
# was silently missing every selector in this file (including the one
# gating apply_check_dummy_hit below) at the old radius, which is why
# mace kills weren't dropping items or showing the one-shot announcement.
# dummy_tagging (default: on) is a separate toggle from tag_attacker
# itself, for turning off JUST the dummy's ability to tag you - e.g. if you
# want to hit dummies freely without triggering your own combat lock while
# still tagging on real player hits.
#
# no_tag_on_one_shot_kill applies here too, same as hitting a real player
# (maybe_tag_attacker.mcfunction/check_one_shot_exemption_attacker.mcfunction) -
# a dummy one-shot means the fight (such as it is) is already over, so
# hit-and-run prevention doesn't apply. $should_tag_attacker defaults to 1
# so this is a no-op when the setting's off.
scoreboard players set $should_tag_attacker scdi_const 1
execute if data storage scdi:config {no_tag_on_one_shot_kill:1b} at @s run function scdi:check_dummy_one_shot_exemption_attacker
execute at @s if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..16] if data storage scdi:config {tag_attacker:1b} if data storage scdi:config {dummy_tagging:1b} if score $should_tag_attacker scdi_const matches 1 run function scdi:on_hurt_by_player_tag_only

# visual feedback ON the dummy that hitting it just tagged you - otherwise
# the only sign anything happened is the attacker's own title/sound/
# actionbar, with nothing near the dummy itself confirming it worked. tied
# to tag_attacker, dummy_tagging, AND $should_tag_attacker - showing
# "tagged" feedback when the one-shot exemption above actually skipped the
# tag would be misleading.
execute at @s as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..16] if data storage scdi:config {tag_attacker:1b} if data storage scdi:config {dummy_tagging:1b} if score $should_tag_attacker scdi_const matches 1 run function scdi:spawn_dummy_tag_display

# dummy hit handling (one-shot announcement + armor-drop-on-death) - always
# checked regardless of the settings above, own gates are per-effect inside
# apply_check_dummy_hit.mcfunction.
execute at @s as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=..16] at @s run function scdi:apply_check_dummy_hit

# reset the advancement so it can fire again on the next hit
advancement revoke @s only scdi:attacked_entity
