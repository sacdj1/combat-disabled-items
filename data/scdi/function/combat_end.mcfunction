# runs exactly once, the instant the stopwatch crosses the duration threshold
scoreboard players set @s scdi_tag 0

# lets the armor/inventory-disabled visual warnings
# (check_armor_warning.mcfunction/check_inventory_warning.mcfunction) show
# again on the next fresh encounter, instead of only ever once per player
# for the whole session.
scoreboard players set @s scdi_armor_warning_shown 0
scoreboard players set @s scdi_inventory_warning_shown 0

# lets check_one_shot.mcfunction's single-hit gate fire again next
# encounter too, same "fresh encounter" boundary as the two flags above -
# without this reset, a player's first-ever hit would permanently block
# one-shot detection for every encounter after it.
scoreboard players set @s scdi_one_shot_hit 0

# stamped every time combat ends, regardless of one_shot_cooldown_enabled -
# check_one_shot.mcfunction reads this to tell "genuinely untouched by
# combat for a while" apart from "just timed out of the last fight a moment
# ago", if that option is on.
scoreboard players operation @s scdi_last_combat_end_tick = $ticks scdi_const

# clear the countdown score so it doesn't linger at its last value under this
# player's nametag if show_timer_above_head is on (a player with no score in
# a below_name objective just shows nothing, instead of a stale frozen number)
scoreboard players reset @s scdi_sec

# remove the floating text_display countdown owned by @s, if any (no-op if
# show_timer_text_display was never on, or @s was never tagged/never got an
# id) - see spawn_timer_display.mcfunction. matched by scdi_owner_id, NOT
# proximity - a distance-based kill here would risk deleting a DIFFERENT,
# still-active player's display if they happened to be standing nearby when
# this player's combat ended. -1 as the fallback is a deliberately invalid
# id (real ids start at 1) so a player who somehow reaches this with no
# scdi_id assigned yet safely matches no display at all, instead of an
# unrelated one via a leftover value from a previous unrelated call.
data modify storage scdi:tmp5 id set value -1
execute store result storage scdi:tmp5 id int 1 run scoreboard players get @s scdi_id
function scdi:apply_kill_timer_display with storage scdi:tmp5

function scdi:restore_check

title @s actionbar {"text":"✔ Combat over - items re-enabled","color":"green"}
function scdi:play_safe_sound
