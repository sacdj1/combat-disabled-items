# entry point, called once per tick for every online player only if
# proximity_tagging is enabled (see load.mcfunction, off by default). keeps
# items disabled continuously while another player stays within
# proximity_distance blocks, independent of (and in addition to) the normal
# hit-based tagging.
# proximity_distance is stored as a double (e.g. 6.0d) for easy editing, but
# macro-substituting it directly into a selector's distance= argument would
# insert the raw "6.0d" text (NBT's typed-literal suffix) - not valid
# selector syntax, and the resulting command silently fails to parse, which
# is why proximity-only tagging never actually triggered. converting through
# "data get ... 1" first strips the suffix by producing a clean int instead.
# myteam defaults to 0 (no team) BEFORE the read below, not after - scdi:tmp3
# is reused across every online player's check within the same tick (this
# function runs once "as @a"), so if the score read ever failed to find a
# value for some reason, myteam would otherwise silently keep whatever the
# PREVIOUS player's team number was, rather than safely falling back to "no
# team". scdi_team itself IS defaulted every tick in tick.mcfunction before
# this ever runs, so this is defense-in-depth, not a fix for a known way the
# read itself fails - but costs nothing to guard against regardless.
data modify storage scdi:tmp3 myteam set value 0

# uses a WIDER distance to keep refreshing an already-tagged player
# (proximity_retag_distance) than to initially trigger the tag in the
# first place (proximity_distance) - an aggro-vs-leash split, so drifting
# slightly further away than the trigger range doesn't immediately drop
# the lock the instant you cross back over the same tight boundary you
# just tagged at. same default (6.0) as proximity_distance out of the box,
# so this is a no-op until you widen it.
execute if score @s scdi_tag matches 1 store result storage scdi:tmp3 dist int 1 run data get storage scdi:config proximity_retag_distance 1
execute unless score @s scdi_tag matches 1 store result storage scdi:tmp3 dist int 1 run data get storage scdi:config proximity_distance 1
execute store result storage scdi:tmp3 myteam int 1 run scoreboard players get @s scdi_team
function scdi:check_proximity_apply with storage scdi:tmp3
