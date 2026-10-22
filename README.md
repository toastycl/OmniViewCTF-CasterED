# OmniViewCTF - Caster Edition UA v2.0

**OmniViewCTF - Caster Edition UA** is the Unreal Arena branded edition of OmniViewCTF - Caster Edition for **Unreal Tournament 99 Capture the Flag**.

Designed for spectators, casters, competitive matches and broadcasts, this edition provides a compact and information-rich CTF spectator interface while preserving the core OmniView experience.

The UA edition is distributed as a separate Unreal Tournament package:

```text
OmniViewCTF_CasterED_UA
```

It can coexist with the standard Caster Edition:

```text
OmniViewCTF_CasterED
```

without replacing or overwriting it.

---

## Version

**OmniViewCTF - Caster Edition UA v2.0**

Developed and maintained by **ToastyCL**  
Unreal Arena branded edition.

---

## Overview

Caster Edition UA focuses on improving the spectator experience for competitive CTF while keeping the match itself visible.

Main features include:

- Compact competitive scoreboard
- Improved spectator HUD
- Item and powerup timers
- Flag Carrier and AMP identification
- Player Cam
- Player Compare
- MVP Focus
- Last Capture tracking
- Floating player names
- Improved chat and kill feed positioning
- Unreal Arena visual branding

---

## Compact CTF Scoreboard

The scoreboard is designed for competitive casting while remaining compact.

Displayed statistics include:

- Player number
- Player name
- Caps
- Grabs
- FC Kills
- Covers
- Seals
- Frags
- Efficiency

Additional indicators include the spectated player, Flag Carrier, AMP status and RED / BLUE team accents.

---

## Spectator HUD

When following a player, the lower spectator HUD can display:

- Player name
- Team
- Health
- Armor
- Flag Carrier status
- AMP status

Free Spectator mode automatically removes player-specific information for a cleaner view.

---

## Item and Powerup Timers

Supported pickups include:

- Damage Amplifier
- Shield Belt
- Keg O' Health
- Armor
- Thigh Pads
- Jump Boots
- Invisibility

Timer states provide visual feedback for available items, normal countdowns and imminent respawns.

### Multiple Shield Belts

When a map contains multiple Shield Belts, timer accents help identify the side:

- **Red** — closer to RED base
- **Blue** — closer to BLUE base
- **Gold** — single or neutral Belt

---

## Last Capture

After a capture, OmniView displays:

```text
Last cap: PlayerName
```

The scorer is resolved using a short SmartCTF replication window to reduce incorrect or unknown capture information.

---

## MVP System

During the final 60 seconds of a timed match, OmniView can display the current predicted MVP.

The calculation considers:

- Caps
- Grabs
- FC Kills
- Covers
- Seals
- Frags
- Efficiency

This is a caster analysis feature and does not replace official SmartCTF statistics.

---

## MVP Focus

A configurable key opens a detailed MVP Focus panel showing the current MVP candidate, team, CTF statistics and calculated MVP score.

Press the same key again to close it.

---

## Player Compare

Player Compare allows the caster to compare two players during a live match.

### Usage

1. Spectate the first player.
2. Press the configured **Player Compare** key.
3. The current player becomes Player A.
4. Change your normal spectator target.
5. The newly spectated player becomes Player B.
6. Press the Player Compare key again to close the panel.

Compared statistics include Caps, Grabs, FC Kills, Covers, Seals, Frags and Efficiency.

---

## Player Cam

Caster Edition UA includes a secondary Player Cam that can remain locked to one player while the main spectator target changes.

### Usage

1. Spectate a player.
2. Press the configured **Player Cam** key.
3. The secondary camera locks to that player.
4. Change the main spectator target normally.
5. Player Cam remains associated with the originally selected player.
6. Press the Player Cam key again to close it.

The Player Cam uses a responsive 16:9 layout and temporarily replaces the normal chat area while active.

### Technical note

Player Cam uses Unreal Engine 1 `DrawPortal`.

For the directly followed player, OmniView uses the available player view rotation. For a remotely locked player, it uses the UT99-compatible replicated pawn rotation.

Because UT99 does not expose identical remote first-person camera information in every client/build configuration, Player Cam should be considered a **first-person-style broadcast view**, not a guaranteed exact reconstruction of the remote player's local view.

---

## Floating Player Names

Floating names adapt to distance and can retain important player-state indicators such as Flag Carrier and AMP.

---

## Chat and Kill Feed

The interface is reorganized for casting:

- Chat appears in the lower-left
- Player Cam temporarily occupies the chat area while active
- Kill feed is positioned below the scoreboard
- Kill feed repositions when the scoreboard is disabled
- Center messages are moved away from the center of gameplay
- The `Say:` prompt is positioned below the scoreboard

---

## Unreal Arena Edition

This edition includes:

- Unreal Arena logo
- Branding enabled by default
- Separate UT99 package namespace
- Independent `.ini` configuration
- Independent Mods menu entry

Package name:

```text
OmniViewCTF_CasterED_UA
```

The neutral and Unreal Arena editions can therefore coexist in the same UT99 installation.

---

## Installation

Copy these files to your Unreal Tournament `System` directory:

```text
OmniViewCTF_CasterED_UA.u
OmniViewCTF_CasterED_UA.int
OmniViewCTF_CasterED_UA.ini
```

Example:

```text
UnrealTournament/
└── System/
    ├── OmniViewCTF_CasterED_UA.u
    ├── OmniViewCTF_CasterED_UA.int
    └── OmniViewCTF_CasterED_UA.ini
```

Start Unreal Tournament after copying the files. The UA edition should appear in the **Mods** menu.

---

## Starting OmniView

Caster Edition UA does not use AutoStart.

Start or stop the HUD manually from:

```text
Mods
→ OmniViewCTF - Caster Edition UA
→ Start / Stop
```

---

## Recommended Configuration

Configure keys for:

- Player Compare
- MVP Focus
- Player Cam

Choose keys that do not conflict with existing UT99 spectator controls.

Additional settings include scoreboard visibility, player numbers, floating names, chat size, kill feed size, item timers, Flag Carrier information, camera behavior and Unreal Arena logo visibility/size.

---

## Building From Source

Recommended source layout:

```text
UnrealTournament/
└── OmniViewCTF_CasterED_UA/
    ├── Classes/
    │   └── *.uc
    └── Textures/
        └── *.pcx / *.bmp
```

Add the package after its standard dependencies in `[Editor.EditorEngine]`:

```ini
EditPackages=UWindow
EditPackages=UMenu
EditPackages=Botpack
EditPackages=OmniViewCTF_CasterED_UA
```

Run from the Unreal Tournament `System` directory:

```text
ucc make
```

A successful build generates:

```text
OmniViewCTF_CasterED_UA.u
```

Caster Edition UA v2.0 has been validated with a clean compile:

```text
Success - 0 error(s), 0 warnings
```

and has been successfully tested in Unreal Tournament 99.

---

## Compatibility

Designed for **Unreal Tournament 99 CTF** spectator environments.

The package uses standard UT99 dependencies including:

- Engine
- Botpack
- UWindow
- UMenu

Some advanced CTF statistics depend on SmartCTF-compatible replicated information.

Behavior may vary depending on UT99 build, renderer, server configuration, CTF mod and SmartCTF version.

---

## Package Separation

Neutral edition:

```text
OmniViewCTF_CasterED
```

Unreal Arena edition:

```text
OmniViewCTF_CasterED_UA
```

Both can be installed simultaneously.

---

## Credits

### Original Project

**OmniView4CTF**  
Original development: **Waylander / double_u**

### Previous Fork

**v1.1 rX edit**

The previous fork history is preserved for project traceability.

### Caster Edition

Development and maintenance: **ToastyCL**

### Unreal Arena Edition

Branded implementation and development: **ToastyCL / Unreal Arena**

---

## License

This project follows the licensing lineage of the original OmniView project and is distributed under:

**Creative Commons Attribution-ShareAlike 4.0 International — CC BY-SA 4.0**

Redistributions and modified versions should preserve the original project credits and applicable license information.

See `LICENSE.txt` for the complete license terms.

---

## Project Philosophy

OmniViewCTF - Caster Edition UA is intended to improve the presentation of competitive Unreal Tournament 99 CTF without changing the game itself.

> Give spectators and casters more useful information while keeping the match itself at the center of the screen.

---

**OmniViewCTF - Caster Edition UA v2.0**  
**Caster Edition development by ToastyCL**  
**Unreal Arena branded edition**  
**Unreal Tournament 99**
