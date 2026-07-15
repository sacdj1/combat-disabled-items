# called with {color:N} (a packed 24-bit RGB int, same representation
# minecraft:dyed_color uses - e.g. 16711680 = red) - unpacks into 0.0-1.0
# RGB float components stored in scdi:tmp29 (r/g/b), for use as macro args
# to apply_disguise_armor_flash_particles.mcfunction (dust particles want
# floats, dyed_color wants the packed int directly, which is why this
# unpacking is only needed for the particle path). plain integer division/
# modulo only - no bitwise ops available in scoreboard operations, but a
# packed RGB int is just base-256 positional encoding
# (color = R*65536 + G*256 + B), so this is exact either way.
$scoreboard players set $color_tmp scdi_const $(color)
scoreboard players operation $color_r scdi_const = $color_tmp scdi_const
scoreboard players operation $color_r scdi_const /= $rgb_65536 scdi_const
scoreboard players operation $color_tmp scdi_const %= $rgb_65536 scdi_const
scoreboard players operation $color_g scdi_const = $color_tmp scdi_const
scoreboard players operation $color_g scdi_const /= $rgb_256 scdi_const
scoreboard players operation $color_b scdi_const = $color_tmp scdi_const
scoreboard players operation $color_b scdi_const %= $rgb_256 scdi_const
execute store result storage scdi:tmp29 r float 0.00392156862745098 run scoreboard players get $color_r scdi_const
execute store result storage scdi:tmp29 g float 0.00392156862745098 run scoreboard players get $color_g scdi_const
execute store result storage scdi:tmp29 b float 0.00392156862745098 run scoreboard players get $color_b scdi_const
