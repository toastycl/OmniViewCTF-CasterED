# OmniViewCTF - Caster Edition v2.2

OmniViewCTF - Caster Edition is a neutral broadcast-oriented fork of OmniViewCTF for Unreal Tournament 99 CTF.

It focuses on giving casters a cleaner spectator HUD, compact live statistics, secondary camera tools, item timing information, and configurable broadcast controls while preserving the original OmniView / SmartCTF workflow.

---

## Version history

### v2.2 - Caster Edition
Current release / edit by **ToastyCL**.

v2.2 adds live weapon information to the spectator bar while preserving the compact single-line broadcast layout.

Highlights:
- Current weapon shown for the player being spectated
- Live ammunition count shown when applicable
- Compact ` | ` separator between player identity and weapon information
- Ammo omitted for Impact Hammer, Translocator and Super Shock Rifle
- Automatic trimming for long player or custom weapon names
- Existing FC / AMP / Boots / HP / Armor layout preserved

### v2.1 - Caster Edition

v2.1 focuses on broadcast polish, Player Cam usability, larger-team support, and improved HUD positioning.

Highlights:
- Frameless Player Cam with team-colored player name
- Smaller centered Player Cam crosshair
- Configurable main-view toggle for `BehindView 0 / 1`
- Improved lower spectator HUD spacing and vertical alignment
- Jump Boots status with remaining charge when available
- Chat moved below the RED scoreboard
- Kill feed remains below the BLUE scoreboard
- Dedicated typing line so `Say:` never overlaps chat
- Scoreboards support more than five players per team
- `FK` label replaces `FCK`
- Cleaner team headers without the redundant `PLAYER` label
- Refined HUD / timer scaling

### v2.0 - Caster Edition
Introduced the neutral Caster Edition package with the compact scoreboard, Player Cam, Player Compare, MVP Focus, item timers, improved spectator HUD, Last Capture, and manual Start / Stop workflow.

### Previous fork
**v1.1 rX edit**

### Original project
Original OmniView4CTF by **Waylander / double_u**.

---

# What's new in v2.2

## Live weapon + ammo in spectator HUD

While following a player, the lower spectator HUD now includes the player's current weapon and remaining ammunition on the same line.

Example:

`Spectating lockpick-JH- [RED] | Flak Cannon 7 | FC | AMP | Boots | HP | Armor`

The weapon information updates live when the observed player changes weapon, fires, picks up ammunition, respawns, or when the caster changes spectator target.

Weapons without a meaningful ammunition counter are shown without a number, including:
- Impact Hammer
- Translocator
- Super Shock Rifle

Long player names or custom weapon names are automatically trimmed to protect the rest of the spectator HUD.

---

# What's new in v2.1

## 1. Compact caster scoreboard

The RED and BLUE scoreboards remain visible in the upper corners without blocking the center of the game.

Displayed statistics:
- Player number
- Player name
- Caps
- Grabs
- Flag Kills (`FK`)
- Covers
- Seals
- Frags
- Efficiency

Additional visual information:
- Spectated player highlight
- Flag Carrier indicator
- AMP indicator
- Team-based RED / BLUE accents
- Efficiency color feedback

### Larger teams

v2.1 removes the previous five-player-per-team internal limit.

The scoreboard now supports up to **16 players per team**, so 6v6 and larger team setups no longer repeat or lose players after the fifth slot.

---

## 2. Improved spectator HUD

When following a player, the lower HUD displays:
- Player name
- Team
- Health
- Armor
- Flag Carrier status
- AMP status
- Jump Boots status

The entire bar is vertically centered with consistent internal padding and spacing.

Compared with the first v2.1 test build, the final spectator bar and item timers were reduced by approximately 10% for a cleaner balance while retaining the larger, more readable v2.0+ presentation.

### Jump Boots

When the observed player has Jump Boots, OmniView displays:

`Boots`

When the replicated charge value is available, it displays the remaining charge:

`Boots 3`  
`Boots 2`  
`Boots 1`

If the remaining charge cannot be determined reliably, OmniView safely falls back to `Boots`.

When using Free Spect, player-specific information is removed and the HUD switches to the cleaner Free Spect layout.

---

## 3. Player Cam

Caster Edition includes an optional secondary Player Cam.

### How to use it

1. Spectate the player you want to follow.
2. Press the configured **Player Cam key**.
3. A secondary camera opens in the lower-left area.
4. The camera locks to that player.
5. You can change your main spectator target while the Player Cam remains locked.
6. Press the Player Cam key again to close it.

### v2.1 Player Cam improvements

- Larger responsive 16:9 viewport
- Frameless presentation
- Team-colored player name in the upper-left corner
- Smaller centered crosshair
- Clean first-person-style POV
- Positioned above the spectator bar and timers
- Chat is temporarily hidden while Player Cam is active

Player Cam uses Unreal Engine 1 `DrawPortal`. Depending on the renderer, first-person weapon rendering or some effects may differ from the normal playable first-person view.

---

## 4. Main spectator view toggle

v2.1 adds a configurable **View toggle key**.

Pressing the assigned key alternates the main spectator camera between:

`BehindView 0`

and

`BehindView 1`

This does not affect the secondary Player Cam.

### Configuration

Open:

**Mod -> OmniViewCTF - Caster Edition**

Then assign a key to:

**View toggle key**

---

## 5. Chat and kill feed layout

The broadcast layout is now symmetrical around the team scoreboards:

- Chat appears directly below the **RED** scoreboard
- Kill feed appears directly below the **BLUE** scoreboard
- Both automatically move down when more players are present
- The `Say:` typing line has its own reserved row
- Existing chat messages begin below the typing line and no longer overlap it
- Player Cam temporarily hides chat while active

This positioning adapts to the actual number of players shown in each team table.

---

## 6. Smart item timers

The timer area supports:
- Damage Amplifier
- Shield Belt
- Armor
- Thigh Pads
- Boots
- Keg
- Invisibility

Timer states include:
- `UP` when available
- Countdown while waiting for respawn
- Visual warning when close to respawning

### Multiple Shield Belts

If a map contains two Shield Belts, both use the compact `BELT` label while team-side accents identify their location.

---

## 7. Powerup ownership

When OmniView can identify the owner reliably, the HUD can show who currently holds important powerups such as AMP and Shield Belt.

The system avoids displaying an owner name when ownership cannot be confirmed.

---

## 8. Last Capture

After a capture, OmniView displays:

`Last cap: PlayerName`

The player name uses the corresponding team color.

A short retry window is used because SmartCTF team score and player capture statistics can replicate on different ticks.

---

## 9. MVP indicator and MVP Focus

During the final 60 seconds of a timed match, OmniView can display the current predicted MVP.

The CTF-oriented calculation uses:
- Caps
- Grabs
- Flag Kills
- Covers
- Seals
- Frags
- Efficiency

A configurable **MVP Focus key** opens the detailed MVP panel.

This is a caster analysis feature and does not replace SmartCTF's official statistics.

---

## 10. Player Compare

Player Compare lets the caster compare two players without opening a full scoreboard.

### How to use it

1. Spectate the first player.
2. Press the configured **Player Compare key**.
3. Change your normal spectator target.
4. The new target becomes Player B.
5. Press the Compare key again to close the panel.

Compared statistics:
- Caps
- Grabs
- Flag Kills
- Covers
- Seals
- Frags
- Efficiency

---

## 11. Floating player names

Floating player names remain visible during spectator mode.

Their presentation adapts to distance while important states such as Flag Carrier and AMP remain identifiable.

---

# Recommended first-time configuration

Open:

**Mod -> OmniViewCTF - Caster Edition**

Configure:

- **Player Compare key**
- **MVP Focus key**
- **Player Cam key**
- **View toggle key**

Choose keys that do not conflict with existing UT99 spectator controls.

---

# Other useful settings

Existing OmniView settings remain available, including:
- Scoreboard visibility
- Player numbers
- Player names
- Chat size
- Kill feed size
- Item timers
- High Contrast mode
- AMP visual behavior
- Flag Carrier information
- Timer visibility
- Pickup visibility

---

# Starting and stopping OmniView

Caster Edition does **not** use AutoStart.

Start and stop the HUD manually from:

**Mod -> OmniViewCTF - Caster Edition -> Start / Stop**

---

# Interface layout

A typical v2.1 layout:

```text
+---------------- RED TEAM ----------------+ +--------------- BLUE TEAM ---------------+
| # RED (n) CAP GRB FK COV SEA FRG EFF    | | # BLUE (n) CAP GRB FK COV SEA FRG EFF  |
| players...                               | | players...                              |
+------------------------------------------+ +------------------------------------------+
 Chat / Say                                  Kill feed

                    Main game view

 [Player Cam - optional]

      Spectating Player | FC | AMP | Boots | HP | Armor
                     Item timers
```

---

# Files

Runtime package:
- `OmniViewCTF_CasterED.u`
- `OmniViewCTF_CasterED.int`
- `OmniViewCTF_CasterED.ini`

Distribution documentation:
- `README.md` - full GitHub documentation
- `README_PACKAGE.txt` - compact README intended for the downloadable ZIP
- `CHANGELOG.md`

---

# Credits

Original OmniView4CTF:
**Waylander / double_u**

Previous fork:
**v1.1 rX edit**

Caster Edition development:
**ToastyCL**

Please keep the original credits and fork history when redistributing modified versions.

---

## Release

**OmniViewCTF - Caster Edition v2.2**

**Caster Edition edit by ToastyCL**

Released: **25 October 2026**
