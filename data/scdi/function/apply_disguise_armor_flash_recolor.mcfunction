# called as+at @s = the tagged player, with {color:N} - fans out to all 4
# armor slots, same pattern as apply_disguise_armor_flash_particles.mcfunction.
$function scdi:apply_disguise_armor_flash_recolor_slot {equip_key:"head",slot_arg:"armor.head",color:$(color)}
$function scdi:apply_disguise_armor_flash_recolor_slot {equip_key:"chest",slot_arg:"armor.chest",color:$(color)}
$function scdi:apply_disguise_armor_flash_recolor_slot {equip_key:"legs",slot_arg:"armor.legs",color:$(color)}
$function scdi:apply_disguise_armor_flash_recolor_slot {equip_key:"feet",slot_arg:"armor.feet",color:$(color)}
