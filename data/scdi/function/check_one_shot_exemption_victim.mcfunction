# called at @s (the victim) from maybe_tag_victim.mcfunction, only when
# no_tag_victim_on_one_shot is on and @s was untagged going into this hit.
# unlike the attacker-side equivalent, no proximity guessing is needed here
# at all - @s IS the victim, so their own Health is read directly. if this
# hit alone killed them, they're about to die/respawn anyway, so tagging
# them is often pointless - and if they stayed tagged instead, a second
# instant-kill test shortly after respawning (reset_on_death off, the
# default) would incorrectly read as "already tagged" and skip the
# one-shot announcement for that second kill too.
execute store result score @s scdi_health run data get entity @s Health 100
execute if score @s scdi_health matches ..0 run scoreboard players set $should_tag_victim scdi_const 0
