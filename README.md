# OmniViewCTF - Caster Edition v2.0

OmniViewCTF - Caster Edition is a neutral broadcast-oriented fork of OmniViewCTF for Unreal Tournament 99 CTF.

This version focuses on providing casters with a cleaner, more compact spectator HUD, additional broadcast tools, and configurable analysis panels, while keeping the original OmniView/SmartCTF information available.

---

## Version history

### v2.0 - Caster Edition
Current release / edit by **ToastyCL**.

Main goals of this version:
- Neutral caster-focused presentation
- No watermark or branding
- New secondary Player Cam
- Improved spectator HUD and scoreboard
- Better timer and powerup information
- Player Compare
- MVP Focus
- Last Capture information
- Manual Start / Stop only

### Previous fork
**v1.1 rX edit**

This Caster Edition keeps the fork history visible for traceability.

### Original project
Original OmniView4CTF by **Waylander / double_u**.

---

# What's new in v2.0

## 1. Compact caster scoreboard

The scoreboard was redesigned to remain visible without covering too much of the game.

Displayed statistics:
- Player number
- Player name
- Caps
- Grabs
- FC Kills
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

The scoreboard is designed to scale correctly across common resolutions.

---

## 2. Improved spectator HUD

When following a player, the lower HUD displays:
- Player name
- Team
- Health
- Armor
- Flag Carrier status
- AMP status

When using Free Spect, the player-specific information is removed and the HUD switches to a cleaner Free Spect layout.

The spectator HUD is responsive and was adjusted to avoid overlaps with timers and other interface elements.

---

## 3. Smart item timers

The timer area supports important pickups such as:
- Damage Amplifier
- Shield Belt
- Armor
- Thigh Pads
- Boots
- Keg
- Invisibility

Timer states include:
- `UP` when the pickup is available
- Countdown while waiting for respawn
- Visual warning when the item is close to respawning

### Multiple Shield Belts

If a map contains two Shield Belts, they are both displayed as `BELT`, but the timer accent identifies the side:

- Red accent = Belt closer to RED base
- Blue accent = Belt closer to BLUE base
- Gold / neutral = single or neutral Belt

This keeps the timer area compact while still making duplicated Belts understandable.

---

## 4. Powerup ownership

When OmniView can identify the owner reliably, the HUD can show who currently holds important powerups such as:
- AMP
- Shield Belt

The system avoids displaying a player name when ownership cannot be confirmed.

---

## 5. Last Capture

After a capture, OmniView displays:

`Last cap: PlayerName`

The player name uses the appropriate team color.

The information stays visible until the next capture.

A short retry window is used because SmartCTF team score and player capture statistics may replicate on different ticks. This helps prevent incorrect `Unknown` capture information.

---

## 6. MVP indicator

During the final 60 seconds of a timed match, OmniView displays the current predicted:

`MVP: PlayerName`

The MVP calculation is designed around CTF contribution rather than frags alone.

It uses:
- Caps
- Grabs
- FC Kills
- Covers
- Seals
- Frags
- Efficiency

This is a caster analysis feature and does not replace SmartCTF's official statistics.

---

## 7. MVP Focus

A configurable key opens the detailed MVP Focus panel.

The panel shows:
- Current MVP candidate
- Team
- Caps
- Grabs
- FC Kills
- Covers
- Seals
- Frags
- Efficiency
- MVP Score contribution

Press the same key again to close the panel.

The panel uses a short broadcast-style transition when opening and closing.

### Configuration

Open:

**Mod -> OmniViewCTF - Caster Edition**

Then assign a key to:

**MVP Focus key**

---

## 8. Player Compare

Player Compare allows the caster to compare two players without opening a full scoreboard.

### How to use it

1. Spectate the first player.
2. Press the configured **Player Compare key**.
3. That player becomes Player A.
4. Change your normal spectator target.
5. The newly spectated player becomes Player B.
6. Press the Compare key again to close the panel.

Compared statistics:
- Caps
- Grabs
- FC Kills
- Covers
- Seals
- Frags
- Efficiency

The panel uses the same transition style as MVP Focus.

### Configuration

Open:

**Mod -> OmniViewCTF - Caster Edition**

Assign a key to:

**Player Compare key**

---

## 9. Player Cam

Caster Edition includes an optional secondary Player Cam.

### How to use it

1. Spectate the player you want to follow.
2. Press the configured **Player Cam key**.
3. A secondary camera opens in the lower-left area.
4. The camera locks to that player.
5. You can change your main spectator view while the Player Cam remains locked.
6. Press the Player Cam key again to close it.

While Player Cam is open, the regular chat is temporarily hidden in that area. Chat returns automatically when Player Cam closes.

The Player Cam uses the player's eye position and rotation to provide a first-person-style POV.

The current stable Player Cam uses the validated **BV0 XLARGE** layout:
- Larger 16:9 window
- Responsive sizing
- Positioned above the lower spectator HUD
- Does not move the main spectator camera
- Does not overlap HP / Armor / FC / AMP / timers

### Important note

Player Cam uses Unreal Engine 1 `DrawPortal`.

Depending on the renderer, first-person weapon rendering or some visual effects may differ from the normal playable first-person view.

### Configuration

Open:

**Mod -> OmniViewCTF - Caster Edition**

Assign a key to:

**Player Cam key**

---

## 10. Floating player names

Floating player names remain visible during spectator mode.

Their presentation changes based on distance:
- Close players: clearer / fuller name
- Medium distance: more compact
- Far distance: smaller and less intrusive

Important states such as Flag Carrier and AMP remain visually identifiable.

---

## 11. Chat and kill feed layout

The interface was reorganized for casting:

- Chat is located at the lower-left
- Kill feed is positioned below the upper scoreboard
- Center messages such as kills, sprees and objective messages are moved higher so they do not block the middle of the action
- The `Say:` typing prompt is positioned below the scoreboard instead of overlapping it

When Player Cam is active, it temporarily replaces the normal chat area.

---

# Recommended first-time configuration

Open:

**Mod -> OmniViewCTF - Caster Edition**

Configure at least the following:

### Player Compare key
Opens / closes Player Compare.

### MVP Focus key
Opens / closes MVP Focus.

### Player Cam key
Opens / closes Player Cam.

Choose keys that do not conflict with your existing UT99 spectator controls.

---

# Other useful settings

Existing OmniView settings are still available, including:
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

This is intentional so the package remains predictable across different caster setups and UT installations.

Start and stop the HUD manually from:

**Mod -> OmniViewCTF - Caster Edition -> Start / Stop**

---

# Interface layout

A typical Caster Edition layout looks like this:

```text
+---------------- RED TEAM --------+ +-------- BLUE TEAM ----------------+
| # Player CAP GRB FCK COV SEA... | | # Player CAP GRB FCK COV SEA... |
| ... | | ... |
+----------------------------------+ +----------------------------------+

 Match score / time


 Main game view


 [Player Cam - optional] Last cap / MVP


 Spectating Player | HP | Armor | FC | AMP
 Item timers / powerups
```

The goal is to keep the game visible while still providing the caster with useful CTF information.

---

# Files

- `OmniViewCTF_CasterED.u`
- `OmniViewCTF_CasterED.int`
- `OmniViewCTF_CasterED.ini`

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

**OmniViewCTF - Caster Edition v2.0**

**Caster Edition v2.0 edit by ToastyCL**

Released: **18 October 2026**
