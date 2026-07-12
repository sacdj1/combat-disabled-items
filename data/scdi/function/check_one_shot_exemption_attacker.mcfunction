# called at @s (the attacker) from maybe_tag_attacker.mcfunction, only when
# no_tag_on_one_shot_kill is on. guesses the victim as the nearest other
# player within melee range and reads their current health - if this hit
# just killed them, the fight is already over, so tagging the attacker
# (whose whole purpose is preventing hit-and-run escape from an ONGOING
# fight) doesn't apply. same acceptable-risk proximity guess as the team
# exemption above - the hit-detection advancement doesn't expose who got hit.
execute unless entity @p[distance=0.01..6] run return 0
execute as @p[distance=0.01..6,sort=nearest,limit=1] store result score $one_shot_victim_hp scdi_const run data get entity @s Health 100
execute if score $one_shot_victim_hp scdi_const matches ..0 run scoreboard players set $should_tag_attacker scdi_const 0
