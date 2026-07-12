# fires on ANY damage taken, but only actually starts combat if pve_mode is
# enabled (default: off, PvP only - see scdi:config pve_mode). when a player
# hits another player, hurt_by_player.json already handles it directly; this
# one just covers everything else (mobs, arrows from mobs, environment, etc.)
execute if data storage scdi:config {pve_mode:1b} run function scdi:on_hurt_by_player_tag_only

# reset the advancement so it can fire again on the next hit
advancement revoke @s only scdi:hurt_by_anything
