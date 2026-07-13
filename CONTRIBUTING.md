# Contributing

Pull requests and issues are welcome. This project is source-available
under a NonCommercial license (see [LICENSE.md](LICENSE.md)) - by
submitting a contribution, you agree it's distributed under those same
terms.

## Before you submit a PR

Run the build/validation script from the repo root:

```
python3 build.py
```

This checks every `.mcfunction`/`.json` reference actually resolves to a
real file, validates JSON syntax, catches macro-function calls missing
their required `with`/inline argument (see below - this one is a silent,
whole-function-breaking failure, not a warning), and checks that every
`/menu`-configurable setting is defined consistently across
`load.mcfunction`, `apply_reset_config.mcfunction`, and
`apply_uninstall.mcfunction`. It exits non-zero and lists every problem
if anything's wrong. A PR that fails this won't be merged.

## Non-obvious gotchas in this codebase

These are all things that silently break with no error message, or a
misleading one, discovered the hard way during development. Read this
before touching combat function logic.

**`summon <entity> ... run function ...` with inline position/NBT fatally
fails to parse.** This game version's summon shorthand cannot take
position or NBT arguments in the same command as a trailing `run function`
- you'll get "Incorrect argument for command" at the exact position, and
the whole function fails to load. Use a bare `summon <entity>` (ambient
position) followed by a separate `data merge entity @s {...}` command for
NBT, or `execute positioned ... summon <entity> run function ...` (still
bare - no inline NBT).

**Macro (`$()`) substitution happens exactly once, at the moment a
function is *invoked*.** If a function writes to the storage path it was
invoked `with`, later `$()` references in that SAME invocation still see
the OLD value from before the write - not the new one. If you need a
freshly-written value, it has to come from a separate, later function call.

**A macro function invoked without a matching `with <source>` (or inline
`{...}`) doesn't just skip the macro line - it silently no-ops the ENTIRE
function, from the first command on.** Any `.mcfunction` file with a
line starting with `$` is a macro function; every single call site, in
every file, must pass it an argument source. `build.py` checks this
automatically, but it's worth understanding why: this exact bug took down
dummy spawning entirely for a while (the very first command in the
function - tagging the entity `scdi_dummy` - never ran, so every
tag-based selector downstream just silently found nothing).

**A line starting with `$` that has no `$(...)` variable anywhere on it is
a HARD function-load error ("No variables in macro"), not a silent no-op.**
Unlike the missing-`with` case above, this one is loud - the whole
function fails to load and every reload logs it - but it's easy to
introduce by copy-pasting a macro line as a template and forgetting to
either add a `$(...)` or remove the leading `$`. `build.py` checks for
this too. This exact typo took down `configure_new_dummy.mcfunction`
entirely for a while (dummy spawning appeared to "just stop working").

**`/data modify entity <player>` cannot touch inventory/equipment.**
Mojang intentionally locked this down since 1.17 as an anti-duplication
fix (MC-123307). `/item modify` / `/item replace` are the sanctioned
replacements for editing a player's held/worn items - but even those have
been observed failing specifically for `armor.chest` on a real player in
testing; a temporary armor-stand relay
(`/item replace entity @s armor.X from entity <temp-stand> armor.X`) is
the one technique confirmed working end-to-end for that slot so far.

**`/item replace ... armor.X from entity <stand>` ALSO silently refuses an
item that isn't equippable in that slot**, even once the relay technique
above is used correctly. Confirmed via a controlled A/B test
(`debug/diagnose_armor_stand_relay.mcfunction` vs `_relay2.mcfunction`):
merging `minecraft:diamond_chestplate` onto the relay stand and copying it
onto a player worked fine, but merging a disguise item like
`minecraft:stick` (no `minecraft:equippable` component) onto the SAME
relay stand and copying it over silently did nothing - the merge onto the
stand itself always succeeds (that write isn't validated at all), it's
specifically the copy onto the *player's armor slot* that gets rejected.
Fix: explicitly add `"minecraft:equippable":{"slot":"<slot>"}` to the
disguise item's components before the relay copy - see
`apply_nullify_armor.mcfunction`/`apply_nullify_equipment_slot.mcfunction`.
This is what was actually breaking elytra disguising, even after the
armor-stand relay itself was already in place and working for real armor
pieces.

**Datapack file changes on disk do NOT take effect until `/reload` runs.**
Obvious in principle, easy to forget mid-session: deploying an updated
`.zip` to the world's `datapacks/` folder has no effect on the currently
running game until the player runs `/reload` (or restarts). A "the fix
still doesn't work" test result is meaningless if no `/reload` happened
between the deploy and the test - always confirm a `Reloading!` log line
exists AFTER the deploy timestamp before trusting a negative test result.

**`execute if entity @e[...]` (existence check) is not the same as
`execute if data entity @e[...] <path>` (NBT path existence check).** The
second form *requires* a trailing NBT path argument - omitting it is a
fatal function-load parse error, not just a logic bug.

**A bare-summoned `minecraft:item` entity gets pruned as "empty"
immediately if you summon it first and set its `Item` NBT in a follow-up
command.** It must be summoned with `Item:{...}` set inline, in one atomic
`summon minecraft:item ~ ~ ~ {Item:{...}}` command.

**`tellraw @s` inside a hit-detection reaction function reaches whoever
that function is executing *as* at that point** - which, depending on how
you got there, might not be the player you expect. When adding debug
output to trace a combat-detection bug, broadcast to `@a` instead of `@s`
so it's visible regardless of execution context.

**A function can silently produce ZERO output - not even its first,
unconditional, non-macro line - despite being invoked with a confirmed-
correct macro argument via `with storage`.** This happened to
`apply_team_confirm_established.mcfunction`: isolated testing proved the
calling condition was true, the storage held exactly the right data, and
a trivial control function called the identical way worked fine right
next to it - yet the real function produced nothing, no error anywhere in
the log, at any log level, across many reloads. The exact mechanism was
never pinned down. The one common thread worth avoiding: the broken
version used `execute ... score @a[scores={someKey=$(val)}] otherObjective
matches ...` - a live score comparison where the *target* selector is
itself filtered by a different score. Rewriting to read that target's
score into a plain scratch score first (`execute as @a[scores={...}] run
scoreboard players operation $scratch objective = @s otherObjective`,
then compare `$scratch` normally) fixed it. If a function you're SURE is
being called produces no output at all, and you're using this selector-
inside-selector pattern, try that rewrite before anything else.

## Project layout

- `data/scdi/function/` - the actual pack logic.
- `data/scdi/function/debug/` - manual diagnostic tools (`/function
  scdi:debug/...`), stripped from the release build by `build.py` but kept
  in the dev build. Feel free to add more of these when chasing a bug -
  they don't need to be as polished as the rest of the pack.
- `build.py` - validates everything above and produces
  `build/combat-disabled-items-dev.zip` (full) and
  `build/combat-disabled-items.zip` (release, no `debug/`).

## Adding a new `/menu`-configurable setting

Every setting needs its default wired into three places, kept in sync
(`build.py` enforces this):

1. `load.mcfunction` - the `execute unless data storage scdi:config <key>
   run data modify storage scdi:config <key> set value <default>` idiom.
2. `apply_reset_config.mcfunction` - forces it back to that same default.
3. `apply_uninstall.mcfunction` - removes the key entirely.

Plus a menu row (in whichever `menu_*_show.mcfunction` page fits best) and
the matching `menu/<setting>_on.mcfunction` / `_off.mcfunction` (or
`suggest_command` for a free-value setting) functions.
