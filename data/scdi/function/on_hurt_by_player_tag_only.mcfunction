# actually applies the "tag @s into combat" effect (title/sound/timer/scdi_tag) - the shared
# core used by every path that can tag a player, each gated by its own setting at the call site:
# the victim path (on_hurt_by_player.mcfunction, gated by tag_victim), the attacker path
# (on_attacked_player.mcfunction, gated by tag_attacker), both PvE paths
# (on_hurt_by_anything.mcfunction / on_attacked_entity.mcfunction, gated by pve_mode), and
# /function scdi:debug/tag (ungated, always tags). this file itself has no gate of its own.

# exemptions, checked before anything else happens - a manually-flagged
# admin (scdi_untaggable) or, if ignore_creative is on, a Creative-mode
# player are both completely immune to being tagged through this path (see
# load.mcfunction for both).
execute if score @s scdi_untaggable matches 1.. run return 0
execute if data storage scdi:config {ignore_creative:1b} if entity @s[gamemode=creative] run return 0

# master switch (hit_tagging_enabled, default on) - see load.mcfunction.
# doesn't touch proximity_tagging, a completely separate path.
execute unless data storage scdi:config {hit_tagging_enabled:1b} run return 0

# ranged-hit exclusion (ranged_attacks_tag, default on) - $hit_was_ranged is
# set by whichever *_ranged.mcfunction reward-function variant called into
# this chain (see on_hurt_by_player_ranged.mcfunction for the full
# explanation), left at 0 by every melee path/debug/tag.
execute if score $hit_was_ranged scdi_const matches 1 unless data storage scdi:config {ranged_attacks_tag:1b} run return 0

# the very first hit always shows the title/sound and starts the timer fresh.
# a follow-up hit while already tagged only restarts the timer if
# retag_resets_timer is on (default: on) - checked BEFORE scdi_tag gets set
# below, since after that it's always 1 and couldn't tell first hit from retag.
execute unless score @s scdi_tag matches 1 run function scdi:on_hurt_by_player_tag_start
execute if score @s scdi_tag matches 1 run function scdi:on_hurt_by_player_retag

scoreboard players set @s scdi_tag 1
