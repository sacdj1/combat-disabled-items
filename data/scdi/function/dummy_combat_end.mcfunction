# called as+at @s = a dummy whose own combat-lock timer just expired.
# restore_check is the same generic function a real player's combat_end
# uses - reconstructs anything currently disguised on this dummy back to
# its real form (elytra, custom armor pieces), same known mainhand/
# firework/wind-charge gap as dummy_combat_active.mcfunction (nothing was
# ever nullified there in the first place, so there's nothing to restore
# there either - self-consistent).
function scdi:restore_check
scoreboard players set @s scdi_dummy_tag 0
