# Combat Disabled Items

Disables firework rockets (mainhand + offhand, including elytra boosting) for
10 real seconds after a player is hit by another player. Getting hit again
resets the timer, so you must go a full 10s without taking damage from
another player before fireworks work again.

Inspired by the NBT-manipulation technique in the `no-elytra-firework-boost`
mod, rewritten for the post-1.20.5 **item component** system
(`minecraft:fireworks`, `minecraft:custom_data`) instead of the old raw NBT
`tag` compound, and driven by a PvP hit-cooldown instead of "is currently
gliding".

## License

Free for personal and non-commercial use under
[CC BY-NC-SA 4.0](LICENSE.md) - share it, modify it, build on it, just
credit the original and don't sell it. Want to run this (or a modified
version) on a server or project that generates revenue in any way? That
needs a separate commercial license - see [LICENSE.md](LICENSE.md) for
contact details.

## How it works

- `data/scdi/advancement/hurt_by_player.json` is a hidden advancement that
  fires whenever a player takes damage whose `source_entity` is another
  player (melee, arrows, tridents, thrown potions, etc.).
- On trigger, `on_hurt_by_player.mcfunction` gives the player a personal
  `/stopwatch` (id `scdi:combat_<n>`, one per player, assigned once via
  `assign_stopwatch_id.mcfunction`) and restarts it back to 0 — this stopwatch,
  not a manually-ticked scoreboard countdown, is the authoritative clock for
  "how long since this player was last hit". It also shows a big red
  "In Combat!" title and plays the configurable combat-tagged sound (see
  Configuration - `play_combat_sound.mcfunction`, default `minecraft:block.note_block.bit`
  at pitch `0.5`). Sound playback is explicitly wrapped in `execute at @s`
  since reward functions aren't guaranteed to carry a position context on
  their own - without that, `~ ~ ~` could resolve far from the player and put
  the sound out of audible range.
- Every tick, for players currently tagged as in-combat, `combat_tick.mcfunction`
  queries that player's stopwatch (`stopwatch query scdi:combat_<n> 1000`, via
  `query_stopwatch.mcfunction`) to get real milliseconds elapsed since their
  last hit:
  - under the configured duration (10000 ms by default): `combat_active.mcfunction`
    re-nullifies any firework rocket in the mainhand/offhand and shows a live
    actionbar countdown ("In Combat - fireworks disabled (Ns)").
  - the instant elapsed time crosses the duration, `combat_end.mcfunction`
    fires exactly once: the original rocket is restored, an actionbar message
    announces combat is over, and the configurable combat-safe sound plays
    (`play_safe_sound.mcfunction`, default the same `minecraft:block.note_block.bit`
    but at pitch `1.0` - same sound, higher pitch reads as "resolved" next to
    the low-pitched "in combat" cue).
- Getting hit again mid-cooldown just calls `restart_stopwatch.mcfunction`
  again, zeroing the elapsed time back to 0 without needing a second id.

**Important `/stopwatch` gotcha**, found by disassembling `StopwatchCommand.class`
with `javap` (not just reading docs, which got this wrong): the command's
result is computed as `(int)(stopwatch.elapsedSeconds() * scale)` — the base
unit is **seconds**, not milliseconds. A scale of `1` silently returns
truncated whole seconds (0, 1, 2, ...), not milliseconds; you need scale
`1000` to get milliseconds. Using scale `1` was the root cause of an earlier
bug where the combat timer barely moved at all. Separately, the actionbar
countdown uses a "round up" trick (`(remaining + 999) / 1000` instead of
plain truncating division) so it reads the full duration (e.g. "30s")
immediately after being tagged, rather than "29s" from the first tick
because a tick or two of real time always passes before the first display
update runs.

**How nullification actually works:** my first attempt just zeroed the
`flight_duration` field of the item's `minecraft:fireworks` component (the
value that's supposed to control elytra boost strength). Empirically that
did **not** fully stop the boost — this game's `FireworkRocketEntity`
lifetime calculation apparently still grants some flight even at
`flight_duration: 0`. So instead, `nullify_mainhand`/`nullify_offhand`
snapshot the item's whole `fireworks` component into a `custom_data` tag,
then use the `minecraft:set_item` loot function to turn the rocket into
**whatever item `scdi:config disguise_item` is set to** (`minecraft:stick`
by default) for the duration of combat — a real type change, not just a
skin, so the boost/throw code has nothing left to trigger on at all. On top
of that, `minecraft:item_model` (a purely visual component, confirmed via
`javap` disassembly of `DataComponents.class` - it's just a plain
`Identifier`, doesn't touch the item's real type or behavior) is set to
whatever `scdi:config disguise_model` is set to (`minecraft:barrier` by
default), so the disguised stick actually *looks* like a barrier in your
hand. Both are independently configurable - see Configuration below.
`restore_mainhand`/`restore_offhand` reverse all of this exactly: swap the
item back to `minecraft:firework_rocket`, restore its original `fireworks`
component (explosion colors/shape, flight duration, everything) from the
`custom_data` snapshot, and remove the `item_model` override (`"!minecraft:item_model"`
in the components patch - the `!` prefix means "remove this component",
confirmed via `DataComponentPatch.REMOVED_PREFIX` in the bytecode).

If the disguise item happens to be a placeable block, `placed_block.json` +
`on_placed_block.mcfunction` watch for any block placement by a currently
locked-out player and instantly clear a small radius around them of any
block matching the disguise item - so trying to place it just doesn't
stick. This only fires for players currently tagged as in-combat, so it
doesn't affect anyone building normally. With the default disguise item
(`minecraft:stick`, not a block), this check is simply a no-op since
there's nothing to place in the first place - it only matters if you
configure a placeable block as the disguise item.

Because a player's currently-held item can't be edited with a plain
`/data modify` (that path is read-only for live entities), all of this goes
through `/item modify` together with **function macros** (`$(fireworks)`,
`$(item)`, `$(model)` substitution) to write the saved/restored component
data and the configured disguise item/model onto the real item.

**Full-inventory scanning** (on by default, see Configuration): the mainhand/
offhand handling above only ever touches whatever's *actively equipped* -
`scan_inventory.mcfunction` adds extra coverage by checking all 36 player
inventory slots (0-35: hotbar + main storage) every tick for any other
firework rockets sitting around unequipped, disguising each one
independently the same way, so a nullified item stays tracked no matter
where you move it within your own inventory. There's no real loop construct
in mcfunctions, so `scan_inventory.mcfunction`/`restore_inventory.mcfunction`
are just 36 near-identical calls (one per slot), each passing the slot
number via an **inline macro argument** (`function scdi:check_hotbar_slot {slot:N}`
- a third way to invoke macros besides `with storage/entity/block`, useful
for small literal values like this; the per-slot helper functions are still
named `..._hotbar_slot` even though they now cover the whole inventory,
since the underlying per-slot logic never actually cared about hotbar vs.
main storage - only the *range* of slots the driver functions call it for
changed). This only reaches your own player inventory - an item dropped on
the ground or placed in a chest isn't tracked while it's outside your
inventory (see Scope/limitations).

**Death handling**: dying doesn't clear the combat lock by default - the
stopwatch keeps running in the background through death/respawn, so you
can't escape it by dying. Detected via a `deathCount`-criteria scoreboard
objective (`scdi_deaths`), comparing it against a per-player "last seen"
value each tick in `tick.mcfunction`/`on_death.mcfunction` - `deathCount`
only ever increases, so any change is unambiguously a death, regardless of
respawn timing. Optionally adjustable to reset on death instead (see
Configuration).

**Tagging the attacker too** (on by default): both the victim and the
attacker get tagged whenever a hit lands, so an attacker can't hit-and-run -
land a hit, then immediately fly away with their own, completely untouched
fireworks. Driven by `tag_attacker`; `attacked_player.json`
(`minecraft:player_hurt_entity`, a *different* trigger that fires **as the
attacker** rather than the victim - this is what makes tagging the actual
attacker possible at all, no nearby-player guessing involved) tags the
attacker the same way the victim gets tagged. Turn it off for victim-only
tagging (the original, pre-`tag_attacker` behavior).

**Turning off victim tagging** (on by default): the flip side of the above -
`tag_victim` controls whether the victim gets tagged at all. It's on by
default (the original, always-on behavior), but turning it off combined with
`tag_attacker` on (also the default) gives you "only the attacker's items
get disabled, not the victim's" - useful if you only want to punish whoever
starts a fight, not whoever gets caught in one. Both settings are
independent and can be combined any way: both (default), victim only,
attacker only, or neither (combat detection/timer still runs either way, it
just won't disguise anything for whichever side is turned off). Both paths -
the victim's
`on_hurt_by_player.mcfunction` and the attacker's `on_attacked_player.mcfunction`
- funnel into the same shared `on_hurt_by_player_tag_only.mcfunction` for the
actual tagging effect (title/sound/timer/`scdi_tag`); each caller applies
its own gate (`tag_victim` / `tag_attacker` / `pve_mode`) before reaching it.

## Scope / limitations

- Only the mainhand and offhand firework rocket item is handled (the actual
  "hold a rocket + hold elytra + right click" escape). Fireworks loaded into
  a crossbow are intentionally left alone to keep the pack simple, since
  firing a crossbow does not boost elytra flight.
- While nullified, the rocket visually/functionally becomes a stack of the
  configured disguise item (same count) until combat ends or it's restored —
  this is intentional (see "How nullification actually works" above). With
  full-inventory scanning on (the default), this is tracked no matter where
  within your own player inventory you move it - restoration is checked
  every tick, both for the exact moment combat ends and as an ongoing safety
  net. It does **not** reach outside your player inventory: an item entity
  dropped on the ground, or one placed into a chest/shulker box/another
  player's inventory, is untracked while it's out there. Nothing bad happens
  if that occurs (it just sits there looking like the disguise item until
  it's back in a player's inventory and gets scanned again) but it also
  won't self-restore while outside any inventory.
- If you deliberately place the disguised item (when it's a block) it gets
  cleared back to air immediately, but the stack count you spent placing it
  is **not** refunded — a minor, intentional cost for trying to circumvent
  the lock, rather than added complexity to make it lossless.
- The anti-placement check assumes nobody else has a legitimate reason to
  place the exact disguise item while tagged as in-combat. Not an issue at
  all with the default (`minecraft:stick` isn't placeable in the first
  place); if you configure a placeable, common survival block as the
  disguise item instead, a combat-tagged player placing a *real* block of
  that same type would also get reverted.
- Disabled/disguised armor might look funky. Worn armor gets its visual
  appearance from `disguise_armor_model` (default `minecraft:leather`,
  a safe vanilla fallback), not from a texture this pack ships - if you set
  it to something that expects a resource pack (a custom equipment asset),
  players without that resource pack installed will see it render oddly.
  Stick with a plain vanilla material here unless you're also distributing
  a matching resource pack to everyone on the server.

## Configuration

- **Cooldown length**: adjustable live, no file editing needed —
  ```
  /scoreboard players set $duration scdi_const <milliseconds>
  ```
  e.g. `/scoreboard players set $duration scdi_const 45000` for 45 seconds.
  Default is `10000` (10s), set in `load.mcfunction`.
- **What counts as "in PvP"**: `data/scdi/advancement/hurt_by_player.json`
  matches any damage whose `source_entity` is a player (so arrows/tridents
  thrown by a player count, not just melee) - this is always active.
- **Proximity tagging** (optional, off by default): instead of (in addition
  to) requiring an actual hit, keeps a player's items disabled continuously
  for as long as another player stays within `proximity_distance` blocks of
  them - `check_proximity.mcfunction`, run every `proximity_interval` ticks.
  ```
  /data modify storage scdi:config proximity_tagging set value 1b   (on)
  /data modify storage scdi:config proximity_tagging set value 0b   (off, default)
  /data modify storage scdi:config proximity_distance set value 6.0
  ```
- **Team exemption** (proximity tagging only): players sharing the same
  non-zero `scdi_team` score never proximity-tag each other, so a grouped
  party can stand together without keeping one another locked. `0`
  (default/unset) means "no team" and never exempts anyone. Not a
  `scdi:config` toggle since it's inherently per-player - assign directly,
  or use the request/confirm flow below:
  ```
  /scoreboard players set <player> scdi_team <number>   (1, 2, 3... whichever side)
  /scoreboard players set <player> scdi_team 0          (no team, default)
  ```
  For HIT-based tagging, teammates hurting each other is already solvable
  with vanilla's own mechanic instead - if they can't damage each other, the
  hit-detection advancement never fires in the first place:
  ```
  /team modify <team> friendlyFire false
  ```
- **Request/confirm teaming up**: a player-facing alternative to setting
  `scdi_team` by hand. `/trigger ScdiTeamRequest` (any player, no op needed)
  sends a request to the nearest other player within 10 blocks - both get
  assigned an `scdi_id` if they don't already have one (the same per-player
  numeric id already used for stopwatches and timer-display ownership), and
  the target gets a clickable `[Accept]` in chat that prefills
  `/trigger ScdiTeamConfirm`. Confirming looks up the requester by that id
  (`scdi_team_requested_by_id`, set on the target when the request is sent),
  checks they're still online, and establishes the team: if the requester
  had no team yet, they're assigned a new one equal to their own `scdi_id`
  (guaranteed unique and non-zero); the confirmer then just joins whatever
  team the requester now has. A third player requesting/confirming with
  either original member naturally joins the same team number, so teams can
  grow past two people this way. Only one pending request is tracked per
  player - confirming always accepts the most recent one sent to you.
  `/trigger ScdiTeamReset` (any player) clears your own `scdi_team` back to
  none - the way to leave a team once you're in one, short of an admin
  resetting it for you.
  ```
  /trigger ScdiTeamRequest
  /trigger ScdiTeamConfirm
  /trigger ScdiTeamReset
  ```
- **Untaggable players** (admin exemption): a player with `scdi_untaggable`
  set to `1` or higher can never be tagged into combat at all, through any
  path - hit, proximity, `tag_attacker`, PvE, even `/function scdi:debug/tag`.
  Checked first thing, before any tagging effect happens. If they're already
  mid-combat when you set this, they're released immediately rather than
  having to wait out the timer. Not exposed as a `scdi:config` toggle since
  it's inherently per-player, same pattern as `scdi_team` above - assign
  directly:
  ```
  /scoreboard players set <player> scdi_untaggable 1   (immune, can't be tagged)
  /scoreboard players reset <player> scdi_untaggable   (normal again, default)
  ```
- **Ignore Creative-mode players**: off by default. When on, a player in
  Creative mode is exempt from tagging entirely, as either victim or
  attacker. Mostly matters for the attacker side - Creative already blocks
  most PvP damage *to* a Creative player in vanilla, but doesn't stop them
  from tagging themselves by hitting someone else while `tag_attacker` is
  on. Also releases anyone already mid-combat the instant they switch into
  Creative. Adjustable live, no file editing needed:
  ```
  /data modify storage scdi:config ignore_creative set value 1b   (exempt Creative players)
  /data modify storage scdi:config ignore_creative set value 0b   (no exemption, default)
  ```
- **PvE mode** (also lock on non-player damage - mobs, environment, etc.):
  off by default. `data/scdi/advancement/hurt_by_anything.json` fires on
  any damage at all, but `on_hurt_by_anything.mcfunction` only actually
  starts the combat lock if this is enabled. Adjustable live, no file
  editing needed:
  ```
  /data modify storage scdi:config pve_mode set value 1b   (enable)
  /data modify storage scdi:config pve_mode set value 0b   (disable, default)
  ```
- **Disguise item** (the rocket's real, functional type while locked out):
  adjustable live, no file editing needed —
  ```
  /data modify storage scdi:config disguise_item set value "minecraft:<item>"
  ```
  e.g. `/data modify storage scdi:config disguise_item set value "minecraft:barrier"`
  (note: barrier is placeable - the anti-placement watcher handles that, see
  above, but placing-and-reverting isn't perfectly invisible). Default is
  `minecraft:stick`, set in `load.mcfunction`. Must be a real, valid
  item id.
- **Disguise model** (purely visual - what the disguise item *looks* like,
  doesn't change its real behavior): adjustable live, no file editing needed —
  ```
  /data modify storage scdi:config disguise_model set value "minecraft:<item>"
  ```
  e.g. `/data modify storage scdi:config disguise_model set value "minecraft:barrier"`.
  Default is `minecraft:barrier`, set in `load.mcfunction`. Must reference a
  real item that has a model (most vanilla items do).
- **Disguise name/color/glint** (the disguised item's display name and
  whether it shows an enchantment glint - both purely cosmetic): default
  name `Items Disabled!` in `red`, `bold`, not italic, with the glint on.
  Adjustable live, no file editing needed:
  ```
  /data modify storage scdi:config disguise_name set value "Items Disabled!"
  /data modify storage scdi:config disguise_name_color set value "red"
  /data modify storage scdi:config disguise_name_bold set value 1b
  /data modify storage scdi:config disguise_name_italic set value 0b
  /data modify storage scdi:config disguise_glint set value 1b
  ```
- **Full-inventory scanning** (extra safety - also catch un-equipped rockets
  sitting anywhere in your inventory, not just the actively-held one): on by
  default.
  ```
  /data modify storage scdi:config scan_inventory set value 1b   (on, default)
  /data modify storage scdi:config scan_inventory set value 0b   (off)
  ```
- **Passive restore** (continuous safety net - actively re-checks and
  restores nulled items for every player who isn't currently in combat,
  every tick, regardless of whether they were ever tagged): on by default.
  This is the more expensive of the two inventory-related settings since it
  runs for every online player every tick, not just recently-combat ones -
  turn it off if you notice lag on a busy server. Turning it off does
  **not** stop items from being restored when combat ends - that always
  happens, exactly once, the instant the "Combat over" message shows; this
  setting only controls the *extra* ongoing checking beyond that moment.
  ```
  /data modify storage scdi:config passive_restore set value 1b   (on, default)
  /data modify storage scdi:config passive_restore set value 0b   (off)
  ```
- **Reset on death**: off by default (timer keeps running through
  death/respawn - dying doesn't let you escape the lock).
  ```
  /data modify storage scdi:config reset_on_death set value 1b   (reset on death)
  /data modify storage scdi:config reset_on_death set value 0b   (keep running, default)
  ```
- **Tag the attacker too** (stops hit-and-run - land a hit, then immediately
  fly away untouched): on by default, both sides get tagged.
  ```
  /data modify storage scdi:config tag_attacker set value 1b   (also tag attacker, default)
  /data modify storage scdi:config tag_attacker set value 0b   (victim only)
  ```
- **Tag the victim** (whether the victim gets tagged at all): on by default.
  Turn off (keeping `tag_attacker: 1b`, also the default) for attacker-only
  tagging - "only the attacker's items get disabled, not the victim's".
  ```
  /data modify storage scdi:config tag_victim set value 1b   (victim gets tagged, default)
  /data modify storage scdi:config tag_victim set value 0b   (victim untouched)
  ```
- **Announce one-shots**: off by default. When on, chat gets a message
  whenever a player's *first* hit of a fresh encounter (not already tagged
  going in) is also the killing blow - `on_hurt_by_player.mcfunction` checks
  `unless score @s scdi_tag matches 1` (i.e. untagged) before tagging runs,
  and `check_one_shot.mcfunction` follows up by checking if they're now
  dead. Deliberately hit-based only - never fires from `proximity_tagging`,
  since standing near someone isn't "getting hit" at all. Can't name the
  attacker: the `entity_hurt_player` advancement this runs from only
  confirms *a* player dealt the damage, not which one (the same limitation
  documented above for `tag_attacker`/`tag_victim` - no reliable way to
  cross-reference attacker identity from the victim's side without guessing
  by proximity).
  ```
  /data modify storage scdi:config announce_one_shot set value 1b   (announce it)
  /data modify storage scdi:config announce_one_shot set value 0b   (off, default)
  ```
- **Combat-tagged sound** (plays the instant someone is tagged into combat):
  ```
  /data modify storage scdi:config combat_sound set value "minecraft:<sound event id>"
  /data modify storage scdi:config combat_pitch set value <0.5-2.0>
  /data modify storage scdi:config combat_volume set value <0.0+>
  ```
  Default `minecraft:block.note_block.bit` at pitch `0.5`, volume `1.0`.
  Volume above `1.0` doesn't get louder past a point - vanilla `/playsound`
  behavior is that values above `1.0` instead extend how far away the sound
  is still audible from.
- **Combat-safe sound** (plays the instant combat ends):
  ```
  /data modify storage scdi:config safe_sound set value "minecraft:<sound event id>"
  /data modify storage scdi:config safe_pitch set value <0.5-2.0>
  /data modify storage scdi:config safe_volume set value <0.0+>
  ```
  Default `minecraft:block.note_block.bit` at pitch `1.0`, volume `1.0` -
  same sound as the combat-tagged cue by default, just full pitch instead of
  low, so the pair reads as "entering" vs "clear" without needing two
  different sounds.
- **Show hotbar/actionbar countdown**: on by default - the "In Combat (Ns)"
  actionbar text (see How it works above). Independent of the two nametag
  options below; turn it off and use one of those instead if you'd rather
  not have text sitting right above your own hotbar.
  ```
  /data modify storage scdi:config show_hotbar_text set value 1b   (show it, default)
  /data modify storage scdi:config show_hotbar_text set value 0b   (off)
  ```
- **Show timer above head** (each tagged player's remaining combat seconds
  shown below their nametag, visible to everyone, not just themselves): off
  by default. Implemented via vanilla's `below_name` scoreboard display slot
  showing the `scdi_sec` objective, labeled just `s` - kept deliberately
  short since belowname always renders `<score> <displayname>` with one
  space in between that can't be closed up (an engine-level separator, not
  something a text component controls), so "7 s" is about as tight as it
  gets. The label's color is actively re-modified every tick in
  `combat_active.mcfunction` to fade through the same phases as the actionbar
  countdown (yellow/white flash for the first second, then red -> gold ->
  yellow across thirds of the duration) - but since `displayname` is a
  single **global** setting shared by every player on that objective (not
  per-player), with more than one fight happening at once whoever's
  `combat_active` runs last each tick "wins" the color for everyone's line,
  not just their own; looks right for the common one-fight-at-a-time case.
  Also note `below_name` itself is a single global slot, so turning this on
  takes it over entirely for as long as it's enabled; if something else
  (another datapack/plugin) is already using it, this will replace it while
  on, and hand it back when turned off. The score is cleared the instant
  combat ends (`combat_end.mcfunction`), so it never lingers showing a stale
  number once someone's no longer tagged.
  ```
  /data modify storage scdi:config show_timer_above_head set value 1b   (on)
  /data modify storage scdi:config show_timer_above_head set value 0b   (off, default)
  ```
- **Show timer above head (floating entity)**: an alternative (or addition)
  to the setting above - instead of the shared `below_name` slot, spawns a
  `minecraft:text_display` entity the instant a player gets tagged,
  positioned well above their nametag rather than tucked right under it,
  with the same live phase-color fade as the actionbar/belowname countdowns
  (this one genuinely is per-player, unlike belowname's shared label). On
  by default. Doesn't touch any global display slot, so it can't conflict
  with another datapack/plugin - safe to run alongside the `below_name`
  option, or on its own. Tried twice to make it "ride" the player as a
  passenger so it would track position automatically (once originally, once
  again after fixing an unrelated text-field syntax bug in case that was the
  real cause) - neither attempt actually stuck, confirmed not working for
  this game version/entity combination. It's instead actively teleported to
  2.6 blocks above the player's exact position every tick from
  `combat_active.mcfunction` (using whichever command `teleport_command`
  names - see Misc below), alongside the text/color rewrite - a real
  world-space position offset, not a `transformation.translation`, since
  translation lives in the entity's own local space and `billboard:"center"`
  constantly re-rotates that local space to face the viewer, which made an
  earlier translation-based offset visibly swing/tilt with viewing angle
  instead of staying a clean vertical lift. `teleport_duration:3`, set once
  at summon, is what makes these every-tick position updates read as smooth
  tracking instead of a visible stutter - without it, each teleport is an
  instant snap (20/sec). Removed the instant combat ends; a periodic sweep
  in `tick.mcfunction` also kills any orphaned one left behind by a player
  disconnecting mid-combat (logging off ejects passengers instead of
  removing them, since text_display entities have no natural despawn timer
  of their own).

  **Multiplayer note**: every per-tick lookup (position tracking, text
  update, the kill on combat-end) targets the display via an exact
  `scdi_owner_id` match set once at spawn (matching the owning player's
  `scdi_id`), not "whichever `scdi_timer_display` entity is nearest me."
  An earlier version used pure proximity for this, which looked fine solo
  but broke as soon as two tagged players ended up near each other - each
  player's tick could grab the *other's* display, since "nearest" doesn't
  reliably mean "mine" once there's more than one in the area. That showed
  up as displays jumping to the wrong person or getting killed prematurely
  when a nearby player's combat ended instead of your own.
  ```
  /data modify storage scdi:config show_timer_text_display set value 1b   (on, default)
  /data modify storage scdi:config show_timer_text_display set value 0b   (off)
  ```
  Turning this on only affects players tagged *after* the change - it
  doesn't retroactively spawn one for anyone already mid-combat.
- **Reset everything to default**: `/function scdi:reset_config` (op only)
  forces every `/menu`-configurable setting - every toggle on every menu
  page, the combat duration and interval scoreboard consts, the disguise
  appearance, sounds, and your entire custom item list (`disguise_targets`
  gets wiped back to empty) - back to its out-of-the-box default in one shot.
  Also available as a button at the bottom of `/menu`'s main hub, which
  prefills the command via chat-suggest rather than running it on a single
  click, so it can't be triggered by an accidental tap. It does **not**
  touch any per-player runtime state - who's currently tagged/in combat,
  stopwatch ids, `scdi_team` assignments, and death tracking are all left
  alone; this only resets the tunable settings themselves.
- **Uninstall**: `/function scdi:uninstall` (op only) - run this **before**
  deleting the datapack from your world's `datapacks/` folder, so nothing's
  left behind. Restores every currently-disguised item for every online
  player (bypassing `scan_inventory` - forced on for this one pass), then
  removes every scoreboard objective, all stored `scdi:config` data, the
  `below_name` display slot (if it's currently showing this pack's timer),
  and any floating timer-display entities. Also best-effort removes each
  player's personal `/stopwatch` - "remove" isn't a `/stopwatch` subcommand
  this pack has ever actually confirmed exists (only `create`/`query`/
  `restart` are verified), so this may silently no-op; harmless either way,
  since stopwatches have no visible presence anywhere in-game. Also
  available as a button at the bottom of `/menu`'s main hub (same
  press-Enter-to-confirm pattern as the reset button above). Two real
  limits: it can only reach **online** players' inventories (an offline
  player with a disguised item needs to log in - with the pack still
  installed - before you delete it), and it obviously can't delete the
  datapack file itself; that's still a manual step afterward.

### Misc

- **Test dummy**: a static `minecraft:mannequin` (`NoAI`, a player-shaped
  target) for testing without needing a second real player. Op-only
  `[Spawn a test dummy here]` / `[Remove all]` buttons live on `/menu` ->
  Misc; the public route is `/trigger ScdiDummy`, which any player (no op
  needed) can use **only if** an admin has turned it on - off by default,
  since unlike everything else in this pack, letting any player spam-summon
  entities from chat unattended is a real clutter/griefing vector:
  ```
  /data modify storage scdi:config allow_dummy_trigger set value 1b   (anyone can /trigger ScdiDummy)
  /data modify storage scdi:config allow_dummy_trigger set value 0b   (disabled, default)
  ```
  Hitting the dummy simulates hitting a real player for **tagging**
  purposes - it tags the attacker exactly like `tag_attacker` does for a
  real player hit, regardless of `pve_mode` (`on_attacked_entity.mcfunction`
  checks for a nearby dummy independently of the normal PvE tagging path,
  since `pve_mode` is meant for genuine mobs, not a dummy that exists
  specifically to simulate PvP). It has no combat-tag state of its own
  though (it's not a player, can't hold a lock on its own items) - only the
  attacker gets tagged.
  Manage the nearest dummy (health, equipped armor, heal/clear-armor/remove
  buttons) via the op-only `[Manage nearest dummy]` button in `/menu` ->
  Misc, or the public `/trigger ScdiDummyMenu` (same `allow_dummy_trigger`
  gate as spawning).
  However it dies, a dummy drops whatever it has equipped as real item
  entities the instant it's confirmed dead
  (`apply_check_dummy_hit.mcfunction` -> `apply_drop_dummy_armor.mcfunction`)
  - not just on a one-shot, any killing blow - then removes itself
  (`kill @s`), since a plain `minecraft:mannequin` has no loot table of its
  own and would otherwise just silently discard whatever it had on. Spawn a
  new one to keep testing. Whenever `tag_attacker` causes a hit on the
  dummy to actually tag you, a brief gold "⚔ Attacker Tagged!" floating
  `text_display` appears above the dummy for 3 seconds
  (`spawn_dummy_tag_display.mcfunction`) - otherwise the only feedback was
  on the attacker's own screen, with nothing near the dummy confirming the
  hit had done anything. Tied directly to `tag_attacker` - no separate
  toggle, since if that's off, hitting the dummy doesn't tag anyone anyway.
- **Dummy max health**: newly spawned dummies get a much larger health pool
  than a real player's 20 (`configure_new_dummy.mcfunction`, via
  `/attribute ... minecraft:max_health`) - gives a wide, unambiguous margin
  before it counts as dead, so drop-on-death reliably fires with room to
  spare, at the cost of no longer being 1:1 comparable to hitting a real
  20-health player. Paired with `dummy_death_threshold` below at `0` (true
  death). Only affects dummies spawned *after* you change this, not existing
  ones.
  ```
  /data modify storage scdi:config dummy_max_health set value 1000
  ```
- **Dummy death threshold**: health value at or below which a dummy counts
  as "dead" (drops its items, gets removed) instead of waiting for exactly
  `0` (`apply_check_dummy_hit2.mcfunction`). Default `0` now that
  `dummy_max_health` above gives it a large pool - raise it if a dummy still
  seems to survive past where it should have died.
  ```
  /data modify storage scdi:config dummy_death_threshold set value 0
  ```
- **Dummy invincible**: per-dummy toggle (not a global default), set via
  `[Make invincible]`/`[Make mortal]` in the dummy menu
  (`menu/dummy_menu_invincible_on.mcfunction`/`_off.mcfunction`, stored on
  the `scdi_dummy_invincible` score). An invincible dummy heals straight
  back to full with a totem-style particle burst on a lethal hit
  (`apply_dummy_invincible_save.mcfunction`) instead of dropping items and
  dying.
- **Dummy passive health regen**: on by default. Once a dummy has gone
  `dummy_regen_delay` ticks without taking any damage, it heals
  `dummy_regen_amount` health every `$dummy_regen_interval` ticks (default
  20 = once a second), clamped to its max health
  (`dummy_regen_tick.mcfunction` -> `apply_dummy_regen_tick.mcfunction` ->
  `apply_dummy_regen_heal.mcfunction`). `scdi_dummy_last_hit` (a global-tick
  timestamp) is reset on every hit, lethal or not - a never-hit dummy has it
  at the default `0`, which trivially satisfies the delay immediately, but
  that's harmless since a never-hit dummy is already at full health.
  ```
  /data modify storage scdi:config dummy_regen set value 1b         (on, default)
  /data modify storage scdi:config dummy_regen set value 0b         (off)
  /data modify storage scdi:config dummy_regen_delay set value 100  (ticks since last hit before regen starts, default 5s)
  /data modify storage scdi:config dummy_regen_amount set value 1   (health per regen tick, default half a heart)
  /scoreboard players set $dummy_regen_interval scdi_const 20       (ticks between regen ticks, default 1s)
  ```
- **Show dummy health**: on by default. A floating current/max health
  readout hovers above each dummy, updated every tick
  (`dummy_health_display_tick.mcfunction`), reflecting damage immediately.
  Uses the same spawn technique as the combat timer display, but without
  owner-id tracking - dummies are stationary, so simple proximity matching
  is safe here. Cleaned up automatically once its dummy is gone (death,
  [Remove]/[Remove all], or uninstall).
  ```
  /data modify storage scdi:config dummy_show_health set value 1b   (on, default)
  /data modify storage scdi:config dummy_show_health set value 0b   (off)
  ```
- **Dummy looks at nearest player**: off by default. When on, every spawned
  dummy turns (position unchanged, rotation only) to face the nearest player
  within `dummy_look_range` blocks, every tick - it has `NoAI` so this is the
  only thing that ever moves it.
  ```
  /data modify storage scdi:config dummy_look_at_player set value 1b   (on)
  /data modify storage scdi:config dummy_look_at_player set value 0b   (off, default)
  /data modify storage scdi:config dummy_look_range set value 10.0
  ```
  The rotation itself is applied via `execute ... anchored eyes facing
  entity ... eyes run <teleport_command> @s ~ ~ ~ ~ ~` (ambient rotation
  from `facing`, baked in via bare `~ ~` rotation args on the final
  command). The `anchored eyes` was the actual fix for an earlier version
  that consistently tilted the dummy's head up too far - without it, the
  angle gets computed from the dummy's default anchor (its feet/base
  position) to the target's eyes, badly exaggerating the pitch at any
  reasonable distance; `anchored eyes` computes it from the dummy's own eye
  position instead, matching how two players naturally look at each other.
- **Dummies pick up/wear armor**: off by default. When on, a dummy equips
  any armor piece dropped within 1.5 blocks of it, every tick
  (`dummy_pickup_tick.mcfunction` -> `apply_dummy_pickup_item.mcfunction`).
  First tries the item's own `minecraft:equippable` component to know it's
  armor and which slot it wants (works for custom/modded items that set it
  explicitly) - but this is essentially dead for standard vanilla armor,
  confirmed via `debug/diagnose_dummy_pickup`: a plain item's stored NBT
  only contains *explicit* component overrides, not its resolved type
  defaults, so a freshly `/given` iron chestplate has no `components` key
  at all. Falls back to matching real vanilla armor item ids directly
  (`apply_dummy_pickup_vanilla_fallback.mcfunction`, all 7 materials x 4
  slots) when the component path doesn't resolve - this is the path that
  actually handles standard armor. Copies the item's full NBT directly into
  the matching `equipment.<slot>` and removes the item entity - simulating
  "picked it up and put it on" via a straight NBT copy, the same technique
  this pack already uses elsewhere to read `equipment.*`. Consumes the
  *entire* dropped stack if there's more than one. If that slot already had
  something equipped, the old piece drops back onto the ground first
  (`apply_dummy_equip_item.mcfunction`) rather than being silently
  discarded - nothing a player worked for in survival should just vanish
  because a dummy picked up something else. A 1-second pickup cooldown
  (shared with the manual `[Drop items]` button) stops the dummy from
  immediately re-picking-up the piece it just dropped and ping-ponging
  between old and new every tick.
  ```
  /data modify storage scdi:config dummy_pickup_items set value 1b   (on)
  /data modify storage scdi:config dummy_pickup_items set value 0b   (off, default)
  ```
- **Announce dummy one-shots**: on by default. A floating "ONE SHOT"
  `text_display` briefly appears (3 seconds) above a dummy the instant it
  dies on its *first-ever* hit - the same "untagged/never-hit going into
  this hit, and now dead" signal `announce_one_shot` uses for players, just
  tracked with `scdi_dummy_hit` instead of combat-tag state (a dummy has no
  tag of its own). Checked from `on_attacked_entity.mcfunction` (the
  attacker-side PvE trigger, which already fires whenever a player hits any
  non-player entity), independent of `pve_mode` - this isn't about combat
  tagging, it's a direct testing-feedback feature. The display is spawned
  via the same "`execute ... summon ... run function ...`" technique as the
  combat timer display (configures itself with no proximity guessing), and
  is swept up by a global-tick-age check in `tick.mcfunction` once it's
  existed for 60 ticks, rather than something tracked/followed like the
  combat timer.
  ```
  /data modify storage scdi:config dummy_announce_one_shot set value 1b   (on, default)
  /data modify storage scdi:config dummy_announce_one_shot set value 0b   (off)
  ```
- **Teleport command**: which command this pack uses internally, everywhere
  it actively repositions/re-orients an entity every tick (currently: the
  floating timer display's tracking above, and the dummy look-at rotation
  just above). `teleport` and `tp` are historically two names for the exact
  same underlying vanilla command (aliases, no known behavioral difference)
  - this setting exists in case that's not true on this specific game
  version, but switching it is **not** the fix for stuttery tracking; that
  turned out to be the display entity's `teleport_duration` field instead
  (see below). Default `teleport`.
  ```
  /data modify storage scdi:config teleport_command set value "teleport"   (default)
  /data modify storage scdi:config teleport_command set value "tp"
  ```

## Sharing your config

The entire OP config is one NBT compound tag living at `scdi:config` in the
world's data storage - not a file on disk, so there's no config file to copy
between worlds. To share it, export the whole compound as text and re-import
it on the other end:

1. On the world with the config you want to share, run:
   ```
   /data get storage scdi:config
   ```
   This prints the full compound tag to chat/console as one long line of
   text (e.g. `{allow_dummy_trigger:0b,disguise_item:"minecraft:stick",...}`).
2. Copy everything from the opening `{` to the closing `}` (the game usually
   prefixes it with something like `scdi has the following...:` - don't
   include that part).
3. On the destination world (same datapack installed and loaded at least
   once, so the objectives/storage exist), run:
   ```
   /data merge storage scdi:config {...paste here...}
   ```
   `merge` overwrites every key present in the pasted compound and leaves
   anything not mentioned untouched - since a full `/data get` dump includes
   every key, this effectively makes the destination's config identical to
   the source's.

No datapack function does this automatically (vanilla commands can't write
to a file on disk), so it's always a manual copy/paste of one command's
output into another command.

## Debugging

Two functions let you test without needing a second player to actually hit you:

- `/function scdi:debug/tag` — puts you into combat exactly as if you'd just
  been hit (assigns/restarts your stopwatch, shows the title, starts
  nullifying).
- `/function scdi:debug/untag` — forces you out of combat immediately,
  regardless of how much time is left, and restores any nulled item on the
  spot.

Run either `as` another player to affect them instead of yourself:
`/execute as <player> run function scdi:debug/tag`.

A handful of deeper diagnostic functions also exist under `scdi:debug/` for
narrowing down a specific stuck step - notably `diagnose_armor` (walks
`disable_elytra`/`elytra_armor`/`nulled_armor` and a full nullify->restore
cycle on your worn chestplate, one line per step) alongside the mainhand-item
equivalents (`diagnose`, `diagnose_real`, `diagnose_custom`, `diagnose_restore`,
`diagnose_removal`, `check_predicates`). Reach for these if something isn't
disabling and it's not obvious why.

## Version note (Minecraft "26.2")

I don't have confirmed data on an exact Minecraft version numbered "26.2" —
that's past my knowledge cutoff. Everything here was verified against the
actual `minecraft-26.2-client.jar` shipped by your instance (decompiled class
strings for the predicate/advancement/loot-function registries) rather than
guessed from older-version docs, since the data component system and JSON
predicate schema both changed in ways older references get wrong. `pack.mcmeta`
uses `pack_format: 81`, confirmed to match your game's actual format from the
error logs during development.

## Install

Copy the `combat-disabled-items` folder (or the zipped version)
into your world's `datapacks/` folder, then run `/reload` (or restart the
world). A chat message confirms it's active - shown to everyone online every
time the pack loads/reloads, styled to match the reload messages in your
other packs (Wolf Sit, Creepers Multiply, One Punch): a green checkmark, the
pack name, "by sacdj" with a clickable link to your Modrinth profile.

## Testing

1. Get a second player (or a test account) to punch you.
2. You should see a red "In Combat!" title and a live actionbar countdown.
3. Try right-clicking a firework rocket while wearing an elytra and gliding —
   you should get no boost, even if you swap the rocket into your hand
   partway through the countdown.
4. Wait for the actionbar to count down to 0 — you'll see "Combat over -
   fireworks re-enabled", and the firework will boost normally again.
5. Get hit again partway through the countdown and confirm it resets back
   to the full duration instead of continuing to count down.

If any specific command errors show up in the game log (`/reload` prints
function errors immediately), send them over and I can adjust the exact
syntax for your version.
