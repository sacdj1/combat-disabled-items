# called as+at @s = the tagged player, with {r,g,b} (0.0-1.0 each) - fans
# out to all 4 armor slots, one dust-particle burst per disguised slot at a
# rough body-height offset for that slot. each one independently checks
# whether it actually holds a disguised (nulled) item before spawning
# anything, so a player who only has one slot disguised (the common case -
# just elytra) doesn't get particles floating at their head/legs/feet too.
$function scdi:apply_disguise_armor_flash_particle_slot {equip_key:"head",y:1.7d,r:$(r),g:$(g),b:$(b)}
$function scdi:apply_disguise_armor_flash_particle_slot {equip_key:"chest",y:1.1d,r:$(r),g:$(g),b:$(b)}
$function scdi:apply_disguise_armor_flash_particle_slot {equip_key:"legs",y:0.6d,r:$(r),g:$(g),b:$(b)}
$function scdi:apply_disguise_armor_flash_particle_slot {equip_key:"feet",y:0.1d,r:$(r),g:$(g),b:$(b)}
