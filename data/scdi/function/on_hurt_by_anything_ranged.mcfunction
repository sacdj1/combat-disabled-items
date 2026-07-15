# ranged counterpart to hurt_by_anything.json/on_hurt_by_anything.mcfunction -
# see on_hurt_by_player_ranged.mcfunction for the full explanation of the
# melee/ranged advancement split and $hit_was_ranged.
scoreboard players set $hit_was_ranged scdi_const 1
function scdi:on_hurt_by_anything
advancement revoke @s only scdi:hurt_by_anything_ranged
