# called with {range:N} - chat fallback for cheating death, scoped to
# players within dummy_announce_range blocks of the dummy instead of the
# whole server.
$tellraw @a[distance=..$(range)] {"text":"⚔ Dummy cheated death!","color":"aqua","bold":true}
