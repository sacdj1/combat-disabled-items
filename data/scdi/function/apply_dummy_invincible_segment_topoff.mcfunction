# called at @s (dummy) from apply_dummy_invincible_segment_check.mcfunction
# when there's still pool left. "cheated death" on a normal-player-sized
# (20 hp) segment of the larger pool, not the whole thing - moves the floor
# down another 20 and snaps raw Health to exactly the new floor+20 (the top
# of the next segment), discarding any overkill past the old floor. the
# floating display and dummy-menu readout
# (apply_compute_dummy_display_health.mcfunction) show Health relative to
# this floor, so this looks and behaves exactly like a normal player's
# health bar refilling to full, over and over, for as long as the
# underlying pool holds out (dummy_max_health / 20 times before the true
# backstop in apply_dummy_invincible_save.mcfunction ever needs to fire).
particle minecraft:totem_of_undying ~ ~1 ~ 0.5 0.5 0.5 0.1 30 force
playsound minecraft:item.totem.use master @a ~ ~ ~ 1.0 1.0
function scdi:spawn_dummy_cheated_death_display
execute if data storage scdi:config {dummy_announce_cheated_death:1b} run tellraw @a {"text":"⚔ Dummy cheated death!","color":"aqua","bold":true}
scoreboard players remove @s scdi_dummy_invincible_floor 20
scoreboard players operation @s scdi_health = @s scdi_dummy_invincible_floor
scoreboard players add @s scdi_health 20
execute store result entity @s Health float 1 run scoreboard players get @s scdi_health

# deliberately does NOT reset scdi_dummy_hit here (unlike the true
# full-exhaustion backstop in apply_dummy_invincible_save.mcfunction) -
# that flag also controls the DPS-tracking window
# (apply_check_dummy_hit.mcfunction resets scdi_dummy_total_dmg/
# scdi_dummy_encounter_start_tick whenever it's unset). segment topoffs
# happen roughly every 20 damage, so resetting it here made the DPS window
# restart constantly mid-fight, producing wildly erratic readings instead
# of a stable running average across the whole test session.
