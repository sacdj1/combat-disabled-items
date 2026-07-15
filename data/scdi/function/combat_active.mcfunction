# throttled to $nullify_interval ticks (default 1 = every tick, see
# load.mcfunction for the tradeoff of raising it) - this is the actual
# mainhand/offhand/armor disguise check, the core of what this pack does.
execute if score $nullify_mod scdi_const matches 0 run function scdi:nullify_check
function scdi:check_disguise_armor_flash

# remaining seconds = ceil((duration_ms - elapsed_ms) / 1000), for the
# actionbar display only. plain (truncating) integer division would show 29
# almost immediately after being tagged (e.g. 29910ms remaining / 1000 = 29,
# not 30) since a tick or two always passes before this first runs - the
# "+ 999 before dividing" trick rounds up instead, so it reads the full
# duration at the start and only ticks down to 29 once truly under 29s remain.
scoreboard players operation @s scdi_sec = $duration scdi_const
scoreboard players operation @s scdi_sec -= @s scdi_elapsed
scoreboard players operation @s scdi_sec += $ceil_offset scdi_const
scoreboard players operation @s scdi_sec /= $div scdi_const

# what % of the combat duration has elapsed so far - drives the actionbar
# color gradient below. works with any $duration, not just the 30s default.
scoreboard players operation @s scdi_pct = @s scdi_elapsed
scoreboard players operation @s scdi_pct *= $hundred scdi_const
scoreboard players operation @s scdi_pct /= $duration scdi_const

# "(Tagged!)" flashes between two colors every ~100ms for the first second
# after being tagged, so the hit actually stands out; the rest of the line
# then fades red -> gold -> yellow across even thirds of the combat duration
# (0-33% / 33-66% / 66-100%)
scoreboard players operation @s scdi_flash = @s scdi_elapsed
scoreboard players operation @s scdi_flash /= $flash_div scdi_const
scoreboard players operation @s scdi_flash %= $two scdi_const

# whether the "- items disabled" part of the actionbar is shown at all -
# see load.mcfunction for the show_disabled_text toggle. each color/flash
# variant below needs both a long and short text version since a title
# command's JSON is static, not conditional at the text level. every variant
# is additionally gated on show_hotbar_text (default on) - off skips the
# actionbar countdown entirely, independent of the two nametag-based options
# further down.
execute if score @s scdi_elapsed matches ..999 if score @s scdi_flash matches 0 if data storage scdi:config {show_disabled_text:1b} if data storage scdi:config {show_hotbar_text:1b} run title @s actionbar ["",{"text":"(Tagged!) ","color":"yellow","bold":true},{"text":"⚔ In Combat - items disabled (","color":"dark_red","extra":[{"score":{"name":"@s","objective":"scdi_sec"}},{"text":"s)"}]}]
execute if score @s scdi_elapsed matches ..999 if score @s scdi_flash matches 0 unless data storage scdi:config {show_disabled_text:1b} if data storage scdi:config {show_hotbar_text:1b} run title @s actionbar ["",{"text":"(Tagged!) ","color":"yellow","bold":true},{"text":"⚔ In Combat (","color":"dark_red","extra":[{"score":{"name":"@s","objective":"scdi_sec"}},{"text":"s)"}]}]
execute if score @s scdi_elapsed matches ..999 if score @s scdi_flash matches 1 if data storage scdi:config {show_disabled_text:1b} if data storage scdi:config {show_hotbar_text:1b} run title @s actionbar ["",{"text":"(Tagged!) ","color":"white","bold":true},{"text":"⚔ In Combat - items disabled (","color":"dark_red","extra":[{"score":{"name":"@s","objective":"scdi_sec"}},{"text":"s)"}]}]
execute if score @s scdi_elapsed matches ..999 if score @s scdi_flash matches 1 unless data storage scdi:config {show_disabled_text:1b} if data storage scdi:config {show_hotbar_text:1b} run title @s actionbar ["",{"text":"(Tagged!) ","color":"white","bold":true},{"text":"⚔ In Combat (","color":"dark_red","extra":[{"score":{"name":"@s","objective":"scdi_sec"}},{"text":"s)"}]}]
execute if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches ..32 if data storage scdi:config {show_disabled_text:1b} if data storage scdi:config {show_hotbar_text:1b} run title @s actionbar {"text":"⚔ In Combat - items disabled (","color":"red","extra":[{"score":{"name":"@s","objective":"scdi_sec"}},{"text":"s)"}]}
execute if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches ..32 unless data storage scdi:config {show_disabled_text:1b} if data storage scdi:config {show_hotbar_text:1b} run title @s actionbar {"text":"⚔ In Combat (","color":"red","extra":[{"score":{"name":"@s","objective":"scdi_sec"}},{"text":"s)"}]}
execute if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches 33..65 if data storage scdi:config {show_disabled_text:1b} if data storage scdi:config {show_hotbar_text:1b} run title @s actionbar {"text":"⚔ In Combat - items disabled (","color":"gold","extra":[{"score":{"name":"@s","objective":"scdi_sec"}},{"text":"s)"}]}
execute if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches 33..65 unless data storage scdi:config {show_disabled_text:1b} if data storage scdi:config {show_hotbar_text:1b} run title @s actionbar {"text":"⚔ In Combat (","color":"gold","extra":[{"score":{"name":"@s","objective":"scdi_sec"}},{"text":"s)"}]}
execute if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches 66.. if data storage scdi:config {show_disabled_text:1b} if data storage scdi:config {show_hotbar_text:1b} run title @s actionbar {"text":"⚔ In Combat - items disabled (","color":"yellow","extra":[{"score":{"name":"@s","objective":"scdi_sec"}},{"text":"s)"}]}
execute if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches 66.. unless data storage scdi:config {show_disabled_text:1b} if data storage scdi:config {show_hotbar_text:1b} run title @s actionbar {"text":"⚔ In Combat (","color":"yellow","extra":[{"score":{"name":"@s","objective":"scdi_sec"}},{"text":"s)"}]}

# floating text_display countdown above the head, if show_timer_text_display
# is on - see spawn_timer_display.mcfunction (spawned once at tag-start) and
# apply_update_timer_display.mcfunction (rewrites its text every tick). color
# mirrors the exact same flash/thirds phases as the actionbar text above, so
# the two stay visually in sync (yellow/white flash for the first second,
# then red -> gold -> yellow across thirds of the duration).
execute if data storage scdi:config {show_timer_text_display:1b} if score @s scdi_elapsed matches ..999 if score @s scdi_flash matches 0 run data modify storage scdi:tmp3 color set value "yellow"
execute if data storage scdi:config {show_timer_text_display:1b} if score @s scdi_elapsed matches ..999 if score @s scdi_flash matches 1 run data modify storage scdi:tmp3 color set value "white"
execute if data storage scdi:config {show_timer_text_display:1b} if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches ..32 run data modify storage scdi:tmp3 color set value "red"
execute if data storage scdi:config {show_timer_text_display:1b} if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches 33..65 run data modify storage scdi:tmp3 color set value "gold"
execute if data storage scdi:config {show_timer_text_display:1b} if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches 66.. run data modify storage scdi:tmp3 color set value "yellow"
execute if data storage scdi:config {show_timer_text_display:1b} store result storage scdi:tmp3 sec int 1 run scoreboard players get @s scdi_sec
execute if data storage scdi:config {show_timer_text_display:1b} store result storage scdi:tmp3 id int 1 run scoreboard players get @s scdi_id
execute if data storage scdi:config {show_timer_text_display:1b} run data modify storage scdi:tmp3 cmd set from storage scdi:config teleport_command
execute if data storage scdi:config {show_timer_text_display:1b} run function scdi:apply_update_timer_display with storage scdi:tmp3

# below_name label color, same phases again - unlike the floating display
# above, this is a single GLOBAL setting (scoreboard objectives can't have a
# per-player displayname), so with more than one player tagged at once
# whoever's combat_active runs last this tick "wins" and sets the color for
# everyone's belowname line, not just their own. looks right for the common
# case (one fight at a time); with several simultaneous fights it'll just
# reflect whichever one most recently ticked, not each player's own phase.
execute if data storage scdi:config {show_timer_above_head:1b} if score @s scdi_elapsed matches ..999 if score @s scdi_flash matches 0 run scoreboard objectives modify scdi_sec displayname {"text":"s","color":"yellow"}
execute if data storage scdi:config {show_timer_above_head:1b} if score @s scdi_elapsed matches ..999 if score @s scdi_flash matches 1 run scoreboard objectives modify scdi_sec displayname {"text":"s","color":"white"}
execute if data storage scdi:config {show_timer_above_head:1b} if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches ..32 run scoreboard objectives modify scdi_sec displayname {"text":"s","color":"red"}
execute if data storage scdi:config {show_timer_above_head:1b} if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches 33..65 run scoreboard objectives modify scdi_sec displayname {"text":"s","color":"gold"}
execute if data storage scdi:config {show_timer_above_head:1b} if score @s scdi_elapsed matches 1000.. if score @s scdi_pct matches 66.. run scoreboard objectives modify scdi_sec displayname {"text":"s","color":"yellow"}
