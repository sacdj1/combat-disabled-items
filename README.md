# Combat Disabled Items

A PvP combat-tag datapack: get hit by another player and your firework
rockets, wind charges, elytra, and any custom items you've configured become
unusable for a set duration - stops "hit and land, then immediately fly
away untouched." Getting hit again refreshes the timer. Includes optional
proximity-based tagging, teams, a full test-dummy system, and a one-shot
kill announcer.

Built for Minecraft "26.2" - see [DEVELOPMENT.md](DEVELOPMENT.md) for a note
on that version and other implementation deep-dives.

## Available as

This project ships in three forms, all implementing the same core combat-tag
concept:

| | Where | Status |
| --- | --- | --- |
| **Datapack** (this folder) | Works on any vanilla-compatible server/singleplayer world, no server software required | Full feature set, most mature |
| **Paper plugin** | [`../combat-disabled-items-plugin`](../combat-disabled-items-plugin) - Paper/Spigot/CraftBukkit-family servers | In development - core combat tagging, item disguising, and config menu/import-export are working; feature parity with the datapack (dummies, one-shot detection, etc.) is ongoing |
| **Fabric/NeoForge mod** | Not started yet | Planned |

If you just want the most complete, battle-tested version, use the datapack.
The plugin exists for server owners who'd rather run a plugin than manage
datapack files, at some performance advantage (event-driven instead of
tick-polled) but with a smaller feature set for now.

## License

Free for personal and non-commercial use under
[CC BY-NC-SA 4.0](LICENSE.md) - share it, modify it, build on it, just
credit the original and don't sell it. Running this (or a modified version)
on a server that generates revenue in any way needs a separate commercial
license - see below for pricing, or [LICENSE.md](LICENSE.md) for full terms.

## Commercial Licensing

If your server generates revenue in any way (donation ranks, a store,
sponsorships, monetized content creators playing on it, etc.), you'll need
a commercial license instead of the default non-commercial terms. Pricing
scales with server size:

| Tier | Server size | Price | Notes |
| --- | --- | --- | --- |
| Small | Under 100 concurrent players, not monetized through content creators/sponsorships | **$15 one-time** | Covers the current version, forever, on that one server. Future Minecraft version updates are a separate $5 one-time fee each, whenever you actually want to upgrade - no subscription. |
| Commercial | 100-500 concurrent players, any monetized network | **$75/year** | Includes the right to updates for new Minecraft versions as they're released, for as long as the license is active. |
| Large | 500-5,000 concurrent players | **$200/year** | Same benefits as Commercial, priced for the larger scale. |
| Very large | 5,000+ concurrent players | **$450/year** | Same benefits, priced for that scale. |
| Enterprise | Multiple large servers, or anything approaching Hypixel-scale | Contact for a custom quote | Pricing depends on scale and what extra support you need. |

To get set up, DM **@sacdj** on Discord starting your message with **"SCDI
License"** so it doesn't get lost among random DMs, along with your server
name, rough player count, and how the server is monetized (if at all).
Payment is via Ko-fi (small tier) or PayPal (everything else) - you'll get
the right link once the tier is confirmed.

## Install

Copy the `combat-disabled-items` folder (or the zipped build) into your
world's `datapacks/` folder, then run `/reload` (or restart the world). A
chat message confirms it's loaded, with a clickable link for `/trigger
ScdiHelp` (in-game help, any player).

## How it works

- Any damage from one player to another (melee, arrows, tridents, thrown
  potions - anything with a player as `source_entity`) tags both the victim
  and the attacker as "in combat" for a configurable duration (default 10s),
  tracked with a real-time `/stopwatch`, not tick counting - so it's
  accurate even under server lag.
- While tagged, configured items (firework rockets by default, optionally
  wind charges/elytra/any custom item you add) get swapped for a disguise
  item and restored the instant combat ends. This reaches your full
  inventory by default, not just what's actively held, so moving a disabled
  item around doesn't let it slip through.
- Getting hit again mid-cooldown refreshes the timer back to full (or
  doesn't - see `retag_resets_timer`).
- Dying doesn't clear the lock by default - you can't escape it by dying
  (see `reset_on_death`).
- Everything is configurable in-game, live, no file editing or restart
  needed - either through the `/menu` GUI (op only) or direct
  `/data modify storage scdi:config <key> set value <value>` commands.
  Players get their own `/trigger ScdiPlayerMenu` for personal preferences
  (warning toggles) that don't need op.

## Configuration

**In-game menu** (recommended): `/function scdi:menu` (op only) walks
through every setting below by category, with live toggles/pickers instead
of typing commands. Players can adjust their own warning preferences via
`/trigger ScdiPlayerMenu` (no op needed).

**Raw commands**: every setting below (except the handful marked
*scoreboard*) follows the same pattern:
```
/data modify storage scdi:config <key> set value <value>
```
Booleans are `1b`/`0b`. Changes apply live and survive `/reload`. The
tables below list every key, its default, and what it does - see
`load.mcfunction` if you want the full reasoning behind a specific one.

<details>
<summary><strong>Combat & tagging</strong></summary>

| Key | Default | Purpose |
| --- | --- | --- |
| `pve_mode` | `0b` | Also lock on non-player damage (mobs, environment), not just PvP. |
| `reset_on_death` | `0b` | Dying ends the lock early instead of it continuing through respawn. |
| `retag_resets_timer` | `1b` | A hit while already tagged refreshes the timer vs. just letting it keep counting down. |
| `tag_attacker` | `1b` | The attacker also gets tagged (stops hit-and-run). |
| `tag_victim` | `1b` | The victim gets tagged at all. Off + `tag_attacker` on = attacker-only punishment. |
| `hit_tagging_enabled` | `1b` | Master switch for all hit-based tagging. Off = proximity-only, if that's on. |
| `ranged_attacks_tag` | `1b` | Arrows/tridents/thrown potions/wind charges count toward tagging, same as melee. |
| `ignore_creative` | `0b` | Creative-mode players are exempt from tagging, either side. |
| *scoreboard* `$duration` | `10000` | Combat lock duration in real milliseconds: `/scoreboard players set $duration scdi_const <ms>`. |

</details>

<details>
<summary><strong>Item disguising</strong></summary>

| Key | Default | Purpose |
| --- | --- | --- |
| `disable_firework_rocket` | `1b` | Firework rockets get disabled while tagged. |
| `disable_wind_charge` | `0b` | Also disable wind charges. |
| `disable_elytra` | `0b` | Also disable the worn elytra. |
| `disguise_targets` | `[]` | Your own list of extra items to disable: `append value {item:"minecraft:<id>",scan_inventory:1b}`. |
| `scan_hotbar` | `1b` | Also catch un-equipped disabled items sitting in the hotbar (slots 0-8). |
| `scan_extended_inventory` | `1b` | Same, for the rest of the backpack (slots 9-35). |
| `passive_restore` | `1b` | Continuously re-check and restore items for players *not* currently tagged (extra safety net; the more expensive setting). |
| `disguise_item` | `"minecraft:stick"` | What a disabled item's real type becomes while locked out. |
| `disguise_model` | `"minecraft:barrier"` | What it visually looks like (held/icon only). |
| `disguise_armor_model` | `"minecraft:leather"` | What disabled *worn armor* looks like (separate from the above - armor needs a real equipment asset id). |
| `disguise_name` / `_color` / `_bold` / `_italic` | `"Items Disabled!"`, `"red"`, `1b`, `0b` | Disguised item's display name styling. |
| `disguise_glint` | `1b` | Disguised item shows an enchant glint. |
| `firework_rocket_duration` / `wind_charge_duration` / `elytra_duration` | `0` (= use global) | Per-item override for how long *that* item stays disabled, in ms. |
| `placement_revert_radius` | `4` | Blocks cleared around a player if they place the disguise item (only matters if it's a placeable block). |

</details>

<details>
<summary><strong>Warnings & sounds</strong></summary>

| Key | Default | Purpose |
| --- | --- | --- |
| `disguise_armor_flash` | `1b` | Red/yellow particle flash around disabled worn armor. |
| `disguise_armor_flash_interval` | `6` | Ticks per flash color phase. |
| `disguise_armor_flash_color_a` / `_b` | red / yellow (packed RGB int) | The two flash colors. |
| `disguise_armor_recolor` | `0b` | Also recolor the armor itself each flash (not just particles) - makes a sound each time, see DEVELOPMENT.md. |
| `disguise_armor_equip_sound` | `"minecraft:block.candle.extinguish"` | Sound played on armor disguise/recolor swaps. |
| `disguise_armor_warning` / `_sound` / `_sound_id` | `1b` / `0b` / note block | Default new-player chat warning (+ optional sound) when worn armor gets disabled. Per-player override via `/trigger ScdiPlayerMenu`. |
| `disguise_inventory_warning` / `_sound` / `_sound_id` | `0b` / `0b` / note block | Same, for a disabled item in a regular inventory slot. |
| `combat_sound` / `_pitch` / `_volume` | note block, `0.5`, `1.0` | Plays the instant a player is tagged. |
| `safe_sound` / `_pitch` / `_volume` | note block, `1.0`, `1.0` | Plays the instant combat ends. |

</details>

<details>
<summary><strong>One-shot detection</strong></summary>

| Key | Default | Purpose |
| --- | --- | --- |
| `announce_one_shot` | `1b` | Chat announcement when a player's first hit of a fresh encounter is also the kill. |
| `one_shot_ignore_tag` | `0b` | Every kill counts as one-shot, not just fresh-encounter kills. |
| `one_shot_cooldown_enabled` / `one_shot_cooldown` | `0b` / `200` (ticks) | Also require the victim to have been out of combat this long - closes the "chip them down, wait out the tag, finish later" loophole. |
| `no_tag_on_one_shot_kill` | `0b` | A one-shot kill doesn't tag the attacker (fight's already over). |
| `no_tag_victim_on_one_shot` | `1b` | A one-shot victim doesn't stay tagged (so repeat instant-kill tests each read as fresh). |

</details>

<details>
<summary><strong>Proximity tagging & teams</strong></summary>

| Key | Default | Purpose |
| --- | --- | --- |
| `proximity_tagging` | `0b` | Keep items disabled continuously while another player is within range, no hit required. |
| `proximity_distance` / `proximity_retag_distance` | `6.0` / `6.0` | Trigger range / stay-tagged range. |
| `proximity_role_by_movement` | `0b` | Infer attacker/victim from who's moving more, instead of tagging both symmetrically. |
| `team_tag_attacker` / `team_tag_victim` | `1b` / `0b` | Whether hitting/being hit by a teammate still tags you (hit-based). |
| `team_tag_proximity` | `0b` | Whether proximity tagging also applies between teammates. |
| *scoreboard* `scdi_team` | `0` (none) | Per-player team number: `/scoreboard players set <player> scdi_team <n>`. Or use `/trigger ScdiTeamRequest` / `ScdiTeamConfirm` / `ScdiTeamReset` for a player-facing request flow. |
| *scoreboard* `scdi_untaggable` | unset | Admin exemption - this player can never be tagged: `/scoreboard players set <player> scdi_untaggable 1`. |

</details>

<details>
<summary><strong>Test dummies</strong></summary>

A `minecraft:mannequin` target for testing without a second player.
`/function scdi:menu` → Misc (op), or the public `/trigger ScdiDummy` /
`ScdiDummyMenu` (gated by `allow_dummy_trigger`).

| Key | Default | Purpose |
| --- | --- | --- |
| `allow_dummy_trigger` | `0b` | Let any player (no op) spawn/manage dummies via `/trigger`. |
| `dummy_tagging` | `1b` | Hitting a dummy tags the attacker, like hitting a real player. |
| `dummy_proximity_tagging` | `1b` | Dummies count as a proximity-tagging source. |
| `dummy_combat_simulation` | `1b` | New dummies simulate their own combat lock (their gear gets disguised too). |
| `dummy_invincible_default` | `0b` | New dummies spawn invincible (heal to full instead of dying) vs. mortal. |
| `dummy_pinned_default` | `0b` | New dummies spawn pinned to their spawn point (stronger than immobile - resists pistons/currents too). |
| `dummy_immobile` | `1b` | Dummies ignore knockback. |
| `dummy_no_gravity` | `0b` | Dummies never fall. |
| `dummy_max_health` | `10000` | Large safety-buffer health pool (not the real death gate, see `dummy_one_shot_damage`). |
| `dummy_one_shot_damage` | `20` | The actual death threshold for a mortal dummy - simulates a real player's 20 HP under sustained damage. |
| `dummy_regen` / `_delay` / `_amount` | `1b` / `100` / `1` | Passive healing once undamaged for `_delay` ticks. |
| `dummy_look_at_player` / `_range` | `1b` / `5` | Dummy turns to face the nearest player in range. |
| `dummy_pickup_items` | `0b` | Dummy equips armor dropped near it. |
| `dummy_show_health` | `1b` | Floating current/max health readout. |
| `dummy_damage_numbers` | `1b` | Floating "-N" popup on every hit. |
| `dummy_announce_one_shot` / `dummy_one_shot_ignore_tag` | `1b` / `0b` | Same one-shot announcement/bypass as the player version, for dummies. |
| `dummy_announce_time_to_kill` | `1b` | Announce how long a kill took. |
| `dummy_announce_cheated_death` | `0b` | Chat message (on top of the always-on floating display) when an invincible dummy cheats death. |
| `dummy_dps_window` | `40` (ticks) | Minimum averaging window for the live DPS readout. |
| `dummy_announce_range` | `24` | How far away players see dummy chat announcements. |
| `dummy_extinguish_in_combat` / `_on_cheat_death` | `0b` / `1b` | New dummies auto-extinguish themselves if on fire. |
| `dummy_cheat_death_invulnerability` | `0b` | Brief immunity window right after cheating death. |
| `dummy_cheat_death_sound_totem` / `_sound_allay` / `_particle` | `1b` / `1b` / electric_spark | Cheat-death heal feedback. |

</details>

<details>
<summary><strong>Display & misc</strong></summary>

| Key | Default | Purpose |
| --- | --- | --- |
| `show_hotbar_text` | `1b` | Actionbar "In Combat (Ns)" countdown. |
| `show_disabled_text` | `1b` | Include "- items disabled" in that actionbar text. |
| `show_tag_title` | `1b` | Big center-screen "In Combat!" title on tag. |
| `show_timer_above_head` / `belowname_restore_objective` | `0b` / `""` | Countdown under the player's nametag (shared global slot - restore key hands it back to whatever used it before, if anything). |
| `show_timer_text_display` | `1b` | Floating countdown display above the player's head (doesn't touch a global slot). |
| `show_team_on_tab` / `tablist_restore_objective` | `0b` / `""` | Show team number in the tab list (same shared-slot pattern as above). |
| `team_request_timeout` | `600` (ticks) | How long a pending `/trigger ScdiTeamRequest` stays open. |
| `teleport_command` | `"teleport"` | Which command moves tracked displays/dummy rotation each tick. |
| `timer_display_teleport_duration` | `3` | Interpolation smoothness for the floating timer display. |
| `debug_custom_items` / `debug_hit_messages` | `0b` / `0b` | Verbose diagnostic chat logging - noisy, leave off unless debugging. |
| *scoreboard* interval tuning | all `1` (every tick) | `$scan_interval`, `$passive_restore_interval`, `$proximity_interval`, `$nullify_interval`, `$combat_tick_interval` - raise any of these on a laggy server to check less often. `$nullify_interval` is the one real tradeoff (delays the actual disguise, not just a safety net); leave the rest at `1` unless you're chasing performance. |

</details>

### Reset & uninstall

- `/function scdi:reset_config` (op) - every setting above back to default. Doesn't touch live combat/team state.
- `/function scdi:uninstall` (op) - run **before** removing the datapack folder. Restores every online player's disabled items, removes all scoreboard objectives/stored config/display entities. Only reaches online players and can't delete the datapack file itself.

Both are also buttons at the bottom of `/menu`.

## Sharing your config

The whole config lives in world data storage, not a file, so sharing it is a
copy/paste of one command's output into another:

```
/data get storage scdi:config
```
Copy the `{...}` it prints, then on the destination world:
```
/data merge storage scdi:config {...paste here...}
```

## Debugging

- `/function scdi:debug/tag` / `scdi:debug/untag` - force yourself (or
  `as <player>`) into or out of combat instantly, without needing a second
  player to hit you.
- `debug_hit_messages` (config key above) prints exactly what each hit
  detection step sees - useful if something isn't tagging/disabling when
  you expect it to.
- More targeted diagnostics live under `scdi:debug/` (`diagnose_armor`,
  `diagnose`, `diagnose_custom`, `diagnose_restore`, etc.) - one per
  specific stuck step.

## Scope / limitations

- Only actively-equipped and in-*your own inventory* items are tracked. An
  item entity dropped on the ground, or placed in a chest/another player's
  inventory, sits untracked (looking like the disguise item) until it's back
  in a player's inventory.
- Placing a disguised item (if it's a placeable block) reverts instantly but
  doesn't refund the stack spent placing it - a small intentional cost.
- Worn disguised armor's appearance depends on `disguise_armor_model` being a
  plain vanilla material; a custom resource-pack asset here will look wrong
  for anyone without that resource pack.
- One-shot/attacker-identity announcements can't name the attacker - the
  advancement this pack relies on only confirms *a* player dealt the damage,
  not which one.

See [DEVELOPMENT.md](DEVELOPMENT.md) for implementation history, bugs found
along the way, and the reasoning behind anything non-obvious above.
