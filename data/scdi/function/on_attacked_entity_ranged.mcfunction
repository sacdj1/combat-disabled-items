# ranged counterpart to attacked_entity.json/on_attacked_entity.mcfunction -
# see on_hurt_by_player_ranged.mcfunction for the full explanation of the
# melee/ranged advancement split and $hit_was_ranged. still runs the full
# shared function including apply_check_dummy_hit - a ranged hit still
# deals real damage and can still one-shot a dummy, only the
# tag-attacker-related lines inside actually check the flag.
scoreboard players set $hit_was_ranged scdi_const 1
function scdi:on_attacked_entity
advancement revoke @s only scdi:attacked_entity_ranged
