# called as+at whichever player just set ScdiDummyAction to a specific
# value via a dummy-menu button click (see dummy_menu_show.mcfunction/
# load.mcfunction's ScdiDummyAction comment/tick.mcfunction) - this runs
# with the SERVER's own full permissions (a function called from a tick
# loop, not a player-triggered command), so it can freely call the actual
# /function targets that a non-op player clicking the button directly
# could never reach themselves. each target function still does its own
# allow_dummy_trigger/proximity/op checks exactly as before - this file
# only solves REACHING them, not authorization.
#
# 2 (clear armor) was removed - it discarded armor permanently with no way
# to get it back, on top of an op/Creative-only gate that turned out
# unreliable once reachable via this dispatcher, and [Drop items] already
# covers getting a dummy's gear off it. numbering below intentionally keeps
# the gap rather than renumbering, since dummy_menu_show.mcfunction's
# buttons reference these values directly.
execute if score @s ScdiDummyAction matches 1 run function scdi:menu/dummy_menu_heal
execute if score @s ScdiDummyAction matches 3 run function scdi:menu/dummy_menu_drop_items
execute if score @s ScdiDummyAction matches 4 run function scdi:menu/dummy_menu_remove
execute if score @s ScdiDummyAction matches 5 run function scdi:menu/dummy_menu_team_add
execute if score @s ScdiDummyAction matches 6 run function scdi:menu/dummy_menu_team_remove
execute if score @s ScdiDummyAction matches 7 run function scdi:menu/dummy_menu_immobile_on
execute if score @s ScdiDummyAction matches 8 run function scdi:menu/dummy_menu_immobile_off
execute if score @s ScdiDummyAction matches 9 run function scdi:menu/dummy_menu_pin_on
execute if score @s ScdiDummyAction matches 10 run function scdi:menu/dummy_menu_pin_off
execute if score @s ScdiDummyAction matches 11 run function scdi:menu/dummy_menu_invincible_on
execute if score @s ScdiDummyAction matches 12 run function scdi:menu/dummy_menu_invincible_off
execute if score @s ScdiDummyAction matches 13 run function scdi:menu/dummy_menu_combat_simulation_on
execute if score @s ScdiDummyAction matches 14 run function scdi:menu/dummy_menu_combat_simulation_off
execute if score @s ScdiDummyAction matches 15 run function scdi:menu/dummy_menu_extinguish_in_combat_on
execute if score @s ScdiDummyAction matches 16 run function scdi:menu/dummy_menu_extinguish_in_combat_off
execute if score @s ScdiDummyAction matches 17 run function scdi:menu/dummy_menu_extinguish_on_cheat_death_on
execute if score @s ScdiDummyAction matches 18 run function scdi:menu/dummy_menu_extinguish_on_cheat_death_off
execute if score @s ScdiDummyAction matches 19 run function scdi:menu/dummy_menu_cheat_death_invuln_on
execute if score @s ScdiDummyAction matches 20 run function scdi:menu/dummy_menu_cheat_death_invuln_off
execute if score @s ScdiDummyAction matches 21 run function scdi:menu/dummy_menu_regen_on
execute if score @s ScdiDummyAction matches 22 run function scdi:menu/dummy_menu_regen_off
execute if score @s ScdiDummyAction matches 25 run function scdi:menu/dummy_menu_cheat_death_particle_totem
execute if score @s ScdiDummyAction matches 26 run function scdi:menu/dummy_menu_cheat_death_particle_soul
execute if score @s ScdiDummyAction matches 27 run function scdi:menu/dummy_menu_cheat_death_particle_sparks
execute if score @s ScdiDummyAction matches 28 run function scdi:menu/dummy_menu_cheat_death_sound_totem_on
execute if score @s ScdiDummyAction matches 29 run function scdi:menu/dummy_menu_cheat_death_sound_totem_off
execute if score @s ScdiDummyAction matches 30 run function scdi:menu/dummy_menu_cheat_death_sound_allay_on
execute if score @s ScdiDummyAction matches 31 run function scdi:menu/dummy_menu_cheat_death_sound_allay_off
