# Development notes

Implementation history and technical deep-dives that don't belong in the
user-facing README - how specific bugs were found, why certain approaches
were tried and abandoned, and the reverse-engineering behind anything not
documented anywhere else. If you just want to use the pack, you don't need
this file.

## Minecraft "26.2"

There's no public reference for a Minecraft version numbered "26.2" as of
this pack's development - past the AI assistant's training cutoff. Everything
was verified against the actual `minecraft-26.2-client.jar` shipped by the
target instance (decompiled class strings for the predicate/advancement/loot-
function registries), not guessed from older-version docs, since the data
component system and JSON predicate schema both changed in ways older
references get wrong. `pack.mcmeta` uses `pack_format: 81`, confirmed against
the game's own error logs during development.

## The `/stopwatch` scale gotcha

Found by disassembling `StopwatchCommand.class` with `javap`, not by reading
docs (which got this wrong): the command's result is computed as
`(int)(stopwatch.elapsedSeconds() * scale)` - the base unit is **seconds**,
not milliseconds. A scale of `1` silently returns truncated whole seconds,
not milliseconds; scale `1000` is required for real millisecond precision.
Using scale `1` was the root cause of an early bug where the combat timer
barely moved at all.

The actionbar countdown also uses a "round up" trick
(`(remaining + 999) / 1000` instead of plain truncating division) so it
reads the full duration (e.g. "30s") immediately after being tagged, rather
than "29s" from the first tick, since a tick or two of real time always
passes before the first display update runs.

## How item nullification actually works (and what didn't work)

The first attempt just zeroed the `flight_duration` field of the item's
`minecraft:fireworks` component. Empirically that did **not** fully stop
elytra boosting - this game's `FireworkRocketEntity` lifetime calculation
apparently still grants some flight even at `flight_duration: 0`.

The working approach instead snapshots the item's whole `fireworks`
component into a `custom_data` tag, then uses `minecraft:set_item` to turn
the rocket into a real different item (`disguise_item`, `minecraft:stick` by
default) for the duration of combat - an actual type change, not a skin, so
the boost/throw code has nothing left to trigger on. `minecraft:item_model`
(confirmed via `javap` disassembly of `DataComponents.class` to be a plain
`Identifier` with no effect on real item type/behavior) is set separately for
the visual disguise. Restoring reverses both: swap the type back, restore the
saved component from `custom_data`, and remove the `item_model` override via
the `"!minecraft:item_model"` remove-prefix syntax (confirmed via
`DataComponentPatch.REMOVED_PREFIX` in the bytecode).

Worn armor needed a second, separate fix: `minecraft:item_model` only
controls the 2D icon/held appearance. The armor-slot equipment renderer
reads `minecraft:equippable`'s `asset_id` field instead, and a disguised item
with no `asset_id` renders as **nothing at all** on the player's body while
worn (confirmed via the game's own docs: an equippable item with no
`asset_id` doesn't render in a non-head slot). `disguise_armor_model` exists
specifically to set a real equipment asset id (vanilla armor material names
like `leather`/`iron`/`diamond`) for this reason - an arbitrary item id like
`disguise_model` uses doesn't work here.

Because a player's currently-held/worn item can't be edited with a plain
`/data modify` (read-only for live entities), all of this goes through
`/item modify` with **function macros** (`$(fireworks)`, `$(item)`,
`$(model)`) to write the saved/restored component data onto the real item.

## Why the armor flash can't be made silent

`disguise_armor_recolor` (repainting the worn armor itself on every flash
phase, not just spawning particles around it) is opt-in and off by default
because every attempt to make it silent failed: `equip_sound` has no volume
control, and no real vanilla sound event is silent by nature. Turning it on
means accepting a sound plays on every color change -
`disguise_armor_equip_sound` at least lets that sound be something less
jarring than the default armor clink (defaults to a soft candle-extinguish
puff).

## Multiplayer display-tracking bug (proximity vs. owner id)

The floating combat-timer text_display and the dummy health/one-shot/tag
displays are all tracked via an exact `scdi_owner_id`/`scdi_dummy_id` match
set once at spawn, not "whichever display entity is nearest me." An earlier
version used pure proximity, which looked fine solo but broke the moment two
tagged players (or two dummies) ended up near each other - each tick could
grab the *other's* display, since "nearest" doesn't reliably mean "mine" once
there's more than one in the area. That showed up as displays jumping to the
wrong person, or getting killed prematurely when a nearby player's combat
ended instead of your own.

Tried twice to make the timer display "ride" the player as a passenger so it
would track position automatically (once originally, once again after fixing
an unrelated text-field syntax bug in case that was the real cause) - neither
attempt stuck, confirmed not working for this game version/entity
combination. It's instead actively teleported to 2.6 blocks above the
player's exact position every tick, using a real world-space position offset
rather than `transformation.translation` - translation lives in the entity's
own local space, and `billboard:"center"` constantly re-rotates that local
space to face the viewer, which made an earlier translation-based offset
visibly swing/tilt with viewing angle instead of staying a clean vertical
lift. `teleport_duration:3`, set once at summon, is what makes the every-tick
position updates read as smooth tracking instead of a visible stutter -
without it, each teleport is an instant 20/sec snap. Confirmed by direct
testing that `teleport` interpolates with this technique and `tp` does not,
on this game version (hence `teleport_command` defaulting to `teleport`, not
because they're expected to differ - they're documented as aliases with no
behavioral difference, but that didn't hold here).

## Dummy look-at-player pitch bug

`execute ... anchored eyes facing entity ... eyes run ...` - the `anchored
eyes` was the actual fix for an earlier version that consistently tilted the
dummy's head up too far. Without it, the angle gets computed from the
dummy's default anchor (feet/base position) to the target's eyes, badly
exaggerating pitch at any reasonable distance. `anchored eyes` computes it
from the dummy's own eye position instead, matching how two players
naturally look at each other.

## Dummy armor pickup: component vs. vanilla fallback

`dummy_pickup_items` first tries an item's own `minecraft:equippable`
component to identify it as armor and which slot it wants - works for
custom/modded items that set it explicitly, but is essentially dead for
standard vanilla armor. Confirmed via `debug/diagnose_dummy_pickup`: a plain
item's stored NBT only contains *explicit* component overrides, not its
resolved type defaults, so a freshly `/given` iron chestplate has no
`components` key at all. The pack falls back to matching real vanilla armor
item ids directly (all 7 materials x 4 slots) when the component path
doesn't resolve - this fallback is what actually handles standard armor in
practice.

## Mace-smash radius bug

`on_attacked_entity.mcfunction`'s dummy-hit detection originally used a
tight ~6-block selector radius, matching what "feels like" melee range. A
mace smash attack lands while the attacker is still falling from height, so
their position at the exact moment the reaction fires can genuinely be
several blocks above the target, not adjacent to it like a normal swing.
This silently missed every selector in the file (including the one gating
`apply_check_dummy_hit`) at the old radius - the reason mace one-shot kills
weren't dropping items or showing the one-shot announcement. Widened to 16
blocks, with `sort=nearest,limit=1` added separately to make sure a *wide*
radius doesn't cause cross-talk between two dummies standing near each
other.

## Invincible dummy: from segmented pool to always-heal-to-full

The original invincible-dummy design gradually depleted a large segmented
health pool, healing back only one segment at a time. That still relied on
the same synchronous "catch it before the game's own death handling wins the
race" trick for **every segment** - a single big enough hit (a mace smash,
especially) could still lose that race partway through the pool and kill the
dummy for real. Simplified to always jumping straight to a full heal
(`apply_dummy_invincible_save.mcfunction`) on any 20+ damage hit. This
doesn't eliminate the race (nothing command-only can), but it does mean
there's only ever one kind of recovery to reason about, and the brief
invulnerability window it can optionally trigger gives real protection
against a rapid follow-up hit re-triggering the race immediately.

## One-shot detection: why the `scdi_one_shot_hit` gate exists

`one_shot_ignore_tag` (bypass the "was this player already tagged" gate) was
added first, without realizing it removed the only thing verifying a kill
actually happened in a single hit. Without an independent gate, turning that
setting on made **every** kill - regardless of how many hits it actually
took - announce as a "one-shot." `scdi_one_shot_hit`, set the instant a
player takes their first hit of a fresh encounter and reset at
`combat_end`/on real death, is the real single-hit gate: it latches after the
very first hit of an encounter (lethal or not) and check_one_shot only ever
announces on that first check. This is correct "one-shot" semantics, not a
bug - a kill that took two hits, even if the second one happens while the
gate looks "fresh," was never a one-shot by definition.

## `/trigger`-vs-`/function` permission gotcha (dummy/player menus)

`/trigger X` runs at permission level 0 (any player can run it), but
`/function scdi:...` runs at permission level 2 (operator-only) **even when
fired via a clickable chat button**. A non-op player clicking a dummy-menu
button was silently failing with a permission error, never reaching the
function's own internal `allow_dummy_trigger` check at all. Fixed by routing
every button through a shared `/trigger ScdiDummyAction set N` (always
allowed), with the tick loop - running with full server permissions -
performing the actual `/function` call on the player's behalf, the same
pattern the `ScdiDummy`/`ScdiDummyMenu` entry-point triggers already used.

## Damage-display-at-world-origin bug

Dummy damage-number popups occasionally spawned at world origin (0,0,0)
instead of above the dummy. Root cause: the expiry/cleanup call in
`tick.mcfunction` was missing an `at @s` context, so the summon command
inherited whatever position context happened to be active at that point in
the tick loop instead of the dummy's actual position. Fixed by adding
`at @s` to the caller.

## DPS-after-cheat-death-heal accuracy bug

After an invincible dummy cheats death (heals back to full), `scdi_health`
and `scdi_dummy_health_fine` weren't being re-synced to the new, higher
Health value - so the next hit's damage-delta calculation compared against a
stale pre-heal number, producing wildly inflated DPS readings for a hit or
two after every cheat-death heal. Fixed by re-syncing both scores immediately
after the heal in `apply_dummy_invincible_save.mcfunction`.

## The recurring equippable-negation restore bug

Several restore paths (`apply_restore_hotbar_slot`, then later discovered
still-broken in `apply_restore_mainhand`/`apply_restore_offhand`) originally
restored a custom item's `minecraft:equippable` component by writing a
negated component (`"!minecraft:equippable"` then re-adding it) directly via
`item modify`. This technique permanently corrupts the component the first
time it's used on a given item stack - it doesn't round-trip cleanly.
The fix was an armor-stand relay rebuild: summon a scratch armor stand,
transfer the item onto it via NBT copy (not a component patch), let the
armor stand's own equipment-slot mechanics rebuild a clean item, then pull it
back off. `debug/diagnose_hotbar_restore_relay.mcfunction` exists to
step through this technique in isolation.

**Lesson for next time a component-negation bug shows up**: grep
`"!minecraft:` across the *entire* function tree before considering the bug
fixed, not just the one function that was reported broken - this exact bug
sat fixed in one restore path and silently still-broken in two others for a
long stretch of testing, because each restore path (armor slot, hotbar,
mainhand, offhand) is a separate near-duplicate function.

## Config codec (plugin) size reduction

Applies to the Paper plugin, not the datapack: config export originally did
a straight `saveToString()` (full YAML) → Deflate → base64. Rebuilt as a
positional-value codec (`ConfigSchema.FIELDS`, a fixed ordered list of every
key) that encodes only values with a 1-character type tag, relying on both
sides already agreeing on the schema by running the same plugin version.
Shrank a typical export code from several hundred characters to roughly 120.
