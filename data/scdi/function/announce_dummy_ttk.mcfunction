# called with {range:N} - time-to-kill readout, scoped to players within
# dummy_announce_range blocks of the dummy instead of the whole server.
# $ttk_hundredths is only ever 0, 5, 10, ..., 95 (see apply_check_dummy_hit2.mcfunction) -
# the single-digit cases (0 and 5) need a leading zero or "3.5s" would
# misread as five tenths instead of the actual 0.05s, so this picks
# between two otherwise-identical messages based on which case it is.
$execute if score $ttk_hundredths scdi_const matches ..9 run tellraw @a[distance=..$(range)] ["",{"text":"☠ Dummy killed in ","color":"gray"},{"score":{"name":"$ttk_whole","objective":"scdi_const"},"color":"yellow"},{"text":".0","color":"yellow"},{"score":{"name":"$ttk_hundredths","objective":"scdi_const"},"color":"yellow"},{"text":"s (full health to dead)","color":"gray"}]
$execute unless score $ttk_hundredths scdi_const matches ..9 run tellraw @a[distance=..$(range)] ["",{"text":"☠ Dummy killed in ","color":"gray"},{"score":{"name":"$ttk_whole","objective":"scdi_const"},"color":"yellow"},{"text":".","color":"yellow"},{"score":{"name":"$ttk_hundredths","objective":"scdi_const"},"color":"yellow"},{"text":"s (full health to dead)","color":"gray"}]
