# called with {dist:N,myteam:N} - @a always includes @s itself at distance
# 0, so starting the range at 0.01 correctly means "some OTHER player", not
# self. team 0 (default/unset) never exempts anyone from anyone - only a
# real (non-zero) team creates any exemption at all, and even then only
# from the specific nearby players/dummies who share it (not "any teammate
# nearby blocks tagging by everyone"). dummies count as proximity sources
# too (see menu/dummy_menu_team_add.mcfunction for teaming up with one) -
# an unset scdi_team on a dummy that was never added to anyone's team
# behaves exactly like team 0 for every check below.
#
# vanilla selectors have no inequality/negation syntax for scores (there is
# no scores={obj=!N}) - "!" is only valid for equality-style arguments like
# type/tag/nbt/predicate, not numeric score ranges. an earlier version used
# scores={scdi_team=!$(myteam)} anyway, which silently failed to parse and
# broke proximity tagging outright for anyone with a team assigned. instead,
# this resets a counter, loops over nearby players/dummies incrementing it
# for each one that does NOT share your team (the standard vanilla idiom for
# "how many entities match" - "matches $(myteam)" IS valid since myteam is a
# literal number by the time the macro substitutes it in, unlike a live
# cross-entity comparison), and only tags if that count is 1 or more.
scoreboard players set $prox_diff scdi_const 0
$execute unless score @s scdi_team matches 1.. if entity @a[distance=0.01..$(dist)] run function scdi:on_proximity_tag
$execute unless score @s scdi_team matches 1.. if entity @e[type=minecraft:mannequin,tag=scdi_dummy,distance=0.01..$(dist)] run function scdi:on_proximity_tag
$execute if score @s scdi_team matches 1.. as @a[distance=0.01..$(dist)] unless score @s scdi_team matches $(myteam) run scoreboard players add $prox_diff scdi_const 1
$execute if score @s scdi_team matches 1.. as @e[type=minecraft:mannequin,tag=scdi_dummy,distance=0.01..$(dist)] unless score @s scdi_team matches $(myteam) run scoreboard players add $prox_diff scdi_const 1
execute if score $prox_diff scdi_const matches 1.. run function scdi:on_proximity_tag
