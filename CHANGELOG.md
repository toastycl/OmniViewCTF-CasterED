# Changelog

## v2.1 - Caster Edition
Edit by **ToastyCL**.

### Player Cam
- Frameless Player Cam presentation
- Team-colored player name in the upper-left corner
- Player Cam viewport increased while preserving 16:9
- Crosshair added and refined to a smaller final size
- Player Cam remains locked while the main spectator target changes

### Spectator HUD
- Improved horizontal spacing and vertical centering
- Refined spectator bar and timer scale
- Jump Boots indicator renamed to `Boots`
- Remaining Jump Boots charge displayed when available
- Safe `Boots` fallback when remote charge data is unavailable

### Spectator controls
- Added configurable **View toggle key**
- Toggles the main spectator camera between `BehindView 0` and `BehindView 1`

### Scoreboard
- `FCK` label changed to `FK`
- Removed redundant `PLAYER` text from RED / BLUE headers
- Expanded internal team arrays from 5 to 16 players
- Fixed repeated / missing players when a team contains more than five players

### Chat and kill feed
- Chat moved below the RED scoreboard
- Kill feed remains below the BLUE scoreboard
- Chat / kill feed positions now follow the actual team-table height
- Reserved a dedicated `Say:` typing row so typed text no longer overlaps chat messages

### Distribution
- Added `README_PACKAGE.txt` for downloadable ZIP packages
- Updated GitHub documentation for v2.1


## v2.0 - Caster Edition
Edit by **ToastyCL**.

### New caster features
- Compact RED / BLUE team scoreboard
- CTF-focused columns: Caps, Grabs, FC Kills, Covers, Seals, Frags and Efficiency
- Improved lower spectator HUD with HP, Armor, FC and AMP states
- Smart item timers and powerup ownership indicators
- Multiple Shield Belt side differentiation
- Persistent Last Capture indicator
- Last-minute MVP prediction
- Manual MVP Focus panel
- Player Compare panel
- Configurable Player Cam
- Responsive floating player names
- Reworked chat, kill feed and center-message positioning
- Responsive layout improvements across resolutions

### Player Cam
- Secondary 16:9 first-person-style camera
- Locks to the selected player independently from the main spectator target
- Temporarily replaces the chat area while active
- XLARGE responsive layout
- Tracking fix for stale remote camera direction
- Compatible Pawn rotation fallback without relying on `RemoteViewPitch`

### Distribution changes
- Package renamed to `OmniViewCTF_CasterED`
- Visible mod name: `OmniViewCTF - Caster Edition`
- AutoStart removed
- Neutral MVP and Player Compare labels
- Main neutral build contains no community-specific watermark

## Previous fork

### v1.1 - rX edit
Previous fork in the lineage used by this project.

## Original project
Original **OmniView4CTF** by **Waylander / double_u**.
