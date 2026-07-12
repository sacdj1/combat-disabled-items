# called "as"+"at" the dummy, from menu/dummy_menu_invincible_on.mcfunction,
# invoked "with storage scdi:config" - reads dummy_max_health straight out
# of scdi:config via macro (see configure_new_dummy.mcfunction's own comment
# for why a macro function needs that "with" at every call site or it
# silently fails to run at all).
#
# primary defense for invincible dummies: a large health pool (reusing the
# same dummy_max_health value as the on-hold "big health on spawn" feature -
# see /menu -> Misc "Dummy max health") so it never realistically reaches 0
# from normal combat in the first place, instead of relying purely on
# apply_dummy_invincible_save.mcfunction's synchronous "catch the lethal hit
# before the game's own death handling" trick, which the comments there
# admit only wins that race "in practice", not by guarantee. that heal-back
# stays wired up as a backstop for the edge case this pool doesn't cover
# (e.g. a raw /kill or one hit bigger than the whole pool).
$attribute @s minecraft:max_health base set $(dummy_max_health)
execute store result entity @s Health float 1 run attribute @s minecraft:max_health get

# starts the "cheated death" segment cycle - first trigger point is 20
# (a normal player's health) below the fresh max, see
# apply_check_dummy_hit2.mcfunction/apply_dummy_invincible_segment_check.mcfunction
# for where this gets checked and stepped down further.
execute store result score @s scdi_dummy_invincible_floor run attribute @s minecraft:max_health get
scoreboard players remove @s scdi_dummy_invincible_floor 20
