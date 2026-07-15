# fires on ANY damage taken, but only actually starts combat if pve_mode is
# enabled (default: off, PvP only - see scdi:config pve_mode). when a player
# hits another player, hurt_by_player.json already handles it directly; this
# one just covers everything else (mobs, arrows from mobs, environment, etc.)

# checked before ANYTHING else, unconditionally, regardless of pve_mode -
# see check_restore_before_death.mcfunction. this is the ONLY hit-reaction
# path that covers non-player damage (fall, lava, mob attacks, environment)
# so it's this file's job to catch a lethal hit from any of those too, not
# just PvP.
function scdi:check_restore_before_death

execute if data storage scdi:config {pve_mode:1b} run function scdi:on_hurt_by_player_tag_only

# reset the advancement so it can fire again on the next hit
advancement revoke @s only scdi:hurt_by_anything

# see on_hurt_by_player.mcfunction for why this cleanup is always safe here
scoreboard players set $hit_was_ranged scdi_const 0
