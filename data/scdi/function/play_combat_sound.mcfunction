data modify storage scdi:tmp sound set from storage scdi:config combat_sound
data modify storage scdi:tmp pitch set from storage scdi:config combat_pitch
data modify storage scdi:tmp volume set from storage scdi:config combat_volume
function scdi:apply_play_combat_sound with storage scdi:tmp
