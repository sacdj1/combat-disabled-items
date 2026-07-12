data modify storage scdi:tmp sound set from storage scdi:config safe_sound
data modify storage scdi:tmp pitch set from storage scdi:config safe_pitch
data modify storage scdi:tmp volume set from storage scdi:config safe_volume
function scdi:apply_play_safe_sound with storage scdi:tmp
