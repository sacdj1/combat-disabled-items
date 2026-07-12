# called at @s (dummy) from apply_check_dummy_hit2.mcfunction, only once
# scdi_health has dropped to or below scdi_dummy_invincible_floor. decides
# whether there's still another 20-point segment left in the large health
# pool (dummy_max_health, applied at toggle-on time - see
# apply_dummy_invincible_max_health.mcfunction) for a "cheated death" top-off
# (apply_dummy_invincible_segment_topoff.mcfunction), or whether the floor
# would go negative - meaning the whole pool is genuinely exhausted, so this
# needs the full/true backstop reheal instead (apply_dummy_invincible_save.mcfunction).
scoreboard players operation $dummy_next_floor scdi_const = @s scdi_dummy_invincible_floor
scoreboard players remove $dummy_next_floor scdi_const 20

execute if score $dummy_next_floor scdi_const matches ..-1 run function scdi:apply_dummy_invincible_save
execute unless score $dummy_next_floor scdi_const matches ..-1 run function scdi:apply_dummy_invincible_segment_topoff
