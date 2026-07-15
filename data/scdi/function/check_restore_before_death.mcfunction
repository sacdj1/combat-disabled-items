# called as @s (a player who just took damage) from on_hurt_by_player.mcfunction/
# on_hurt_by_anything.mcfunction, as the very first thing either does -
# before any tagging/one-shot logic, regardless of tag_victim/pve_mode/
# reset_on_death. vanilla drops a dying player's EQUIPPED items (including
# whatever's currently disguised) as real item entities before any
# datapack reaction gets a chance to run, if the keepInventory gamerule is
# off - meaning a player who dies while tagged would drop the disguise
# stick/decoy itself, permanently losing their real armor (id and all),
# not just its cosmetic look. restoring immediately here, synchronously in
# the SAME damage-processing step as the hit itself (advancement rewards
# fire as a direct reaction to the damage already being applied), races
# against that drop - the same technique apply_dummy_invincible_save.mcfunction
# already relies on to reheal a dummy before the game's own death handling
# finalizes, "reliably winning in practice" per that file's own comments,
# not by hard guarantee (mace-class instant-kill damage can still lose the
# race - see apply_dummy_invincible_save.mcfunction's history). doesn't
# touch scdi_tag/combat state at all, purely restores items - if
# keepInventory is on, or the player wasn't disguised, this is a harmless
# no-op (restore_check already no-ops on nothing-to-restore, and anything
# it does restore just gets re-disguised next tick if they're still tagged
# and alive, since nullify_check runs unconditionally every combat_tick).
execute store result score $victim_health scdi_const run data get entity @s Health 1
execute if score $victim_health scdi_const matches ..0 run function scdi:restore_check
