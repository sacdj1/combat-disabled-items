# called as a still-alive scdi_dummy_tag_display entity, from
# apply_expire_dummy_tag_display.mcfunction. alternates yellow/white every
# other tick, same as the real "just tagged" flash.
scoreboard players operation $tag_flash scdi_const = $ticks scdi_const
scoreboard players operation $tag_flash scdi_const %= $two scdi_const
execute if score $tag_flash scdi_const matches 0 run data merge entity @s {text:{text:"⚔ Attacker Tagged!",color:"yellow",bold:true}}
execute if score $tag_flash scdi_const matches 1 run data merge entity @s {text:{text:"⚔ Attacker Tagged!",color:"white",bold:true}}
