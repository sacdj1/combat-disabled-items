# called at @s (the dummy) from apply_check_dummy_hit2.mcfunction, any time
# an invincible dummy's Health crosses its floor (max_health - 20) - i.e.
# any hit (or accumulation of hits since the last heal) dealing 20+ damage.
# simplified from an earlier gradually-depleting segmented pool (see git
# history/apply_dummy_invincible_segment_topoff.mcfunction, removed) to
# this single always-heal-to-full backstop - a segmented pool still relied
# on this same synchronous race for every segment, so a big enough single
# hit (a mace smash, especially) could still lose that race partway through
# and kill the dummy for real despite being "invincible". heals straight
# back to full with a "cheated death" particle burst instead of dropping
# items and actually dying, and resets the floor back to max-20 so this
# fires again clean on the next 20+ damage. runs synchronously in the SAME
# damage-processing step as the hit itself (advancement rewards fire as a
# direct reaction to the damage already being applied), reliably winning
# the race against the game's own internal death handling in practice
# (though, per the above, not with a hard guarantee against every possible
# single hit) - the same technique this pack used exclusively for every
# dummy before drop-on-death became the default.
# does NOT reset scdi_dummy_hit (unlike an older version of this file) -
# that flag also gates DPS/total-damage tracking's "fresh encounter" reset
# (apply_check_dummy_hit.mcfunction). resetting it here made sense back
# when this was a rare, once-in-a-while full-exhaustion event (basically a
# real death), but now that cheating death fires on every single 20+
# damage hit, resetting it here wiped the DPS baseline constantly - a
# player attacking an invincible dummy could never build up a meaningful
# reading, since almost every hit looked like "the first hit of a brand
# new fight" to the tracker. [Heal to full]/passive regen still reset it
# themselves when appropriate; this path just heals the raw health back,
# nothing else about the ongoing encounter.
# per-dummy (ScdiCheatDeathParticle entity NBT - scores can't hold
# strings, see configure_new_dummy.mcfunction), falling back to the global
# default for a dummy that somehow doesn't have the tag (spawned by an
# older version of this pack before a reload). toggleable via the dummy
# trigger menu; global default in /menu -> Misc.
data modify storage scdi:tmp30 particle set from storage scdi:config dummy_cheat_death_particle
execute if data entity @s ScdiCheatDeathParticle run data modify storage scdi:tmp30 particle set from entity @s ScdiCheatDeathParticle
function scdi:apply_dummy_cheat_death_particle with storage scdi:tmp30
# two independent per-dummy toggles (scdi_dummy_cheat_death_sound_totem/
# scdi_dummy_cheat_death_sound_allay, both default on for newly spawned
# dummies - see load.mcfunction's dummy_cheat_death_sound_totem/_allay
# comments and the dummy trigger menu) - either/both/neither can be on,
# the particle burst always plays regardless of both.
execute if score @s scdi_dummy_cheat_death_sound_totem matches 1.. run playsound minecraft:item.totem.use master @a ~ ~ ~ 1.0 1.0
# allay hum layered on top - a little "helper" flavor for now, ahead of
# a planned future feature where the dummy actually uses a totem item (an
# allay literally fetching/using one) rather than just this NBT-only
# heal-back.
execute if score @s scdi_dummy_cheat_death_sound_allay matches 1.. run playsound minecraft:entity.allay.ambient_with_item master @a ~ ~ ~ 1.0 1.0
function scdi:spawn_dummy_cheated_death_display
execute if data storage scdi:config {dummy_announce_cheated_death:1b} store result storage scdi:tmp26 range int 1 run data get storage scdi:config dummy_announce_range 1
execute if data storage scdi:config {dummy_announce_cheated_death:1b} run function scdi:announce_dummy_cheated_death with storage scdi:tmp26
execute store result entity @s Health float 1 run attribute @s minecraft:max_health get
execute store result score @s scdi_dummy_invincible_floor run attribute @s minecraft:max_health get
scoreboard players remove @s scdi_dummy_invincible_floor 20

# re-sync the tracked health scores to match the heal above - without this,
# apply_check_dummy_hit.mcfunction's damage-delta math for the NEXT hit
# would subtract from the STALE pre-heal value instead of the real current
# (now full) health, silently underreporting that hit's damage by however
# much was just healed back (sometimes even negative, which failed the
# "matches 1.." check entirely and dropped the hit from DPS/total-damage
# tracking altogether) - this was why DPS read low/wrong specifically
# against invincible dummies once cheating death started firing routinely.
execute store result score @s scdi_dummy_health_fine run data get entity @s Health 10
execute store result score @s scdi_health run data get entity @s Health 1

# self-extinguish on cheating death (per-dummy toggle, off by default for
# newly spawned dummies - see load.mcfunction's dummy_extinguish_on_cheat_death
# comment)
execute if score @s scdi_dummy_extinguish_on_cheat_death matches 1.. run function scdi:check_dummy_extinguish

# brief damage immunity after cheating death, same idea as a real player's
# own post-respawn window (per-dummy toggle, on by default for newly
# spawned dummies - see load.mcfunction's dummy_cheat_death_invulnerability
# comment). now fires on every heal-back (this is the only invincible-save
# path left), not just a rare full-exhaustion event - deliberately kept: it
# doubles as protection against a rapid follow-up hit re-triggering the
# race again immediately after a heal, which is exactly the "repeated mace
# one-shots" scenario this whole simplification was built to survive.
execute if score @s scdi_dummy_cheat_death_invuln matches 1.. run function scdi:apply_dummy_start_cheat_invuln
