# ranged counterpart to attacked_player.json/on_attacked_player.mcfunction -
# see on_hurt_by_player_ranged.mcfunction for the full explanation of the
# melee/ranged advancement split and $hit_was_ranged.
scoreboard players set $hit_was_ranged scdi_const 1
function scdi:on_attacked_player
advancement revoke @s only scdi:attacked_player_ranged
