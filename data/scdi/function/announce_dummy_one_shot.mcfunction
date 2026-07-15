# called with {range:N} - chat fallback for a dummy one-shot kill, scoped
# to players within dummy_announce_range blocks of the dummy (position
# context already at the dummy - see apply_check_dummy_hit2.mcfunction)
# instead of the whole server.
$tellraw @a[distance=..$(range)] {"text":"⚔ Dummy was ONE-SHOT!","color":"red","bold":true}
