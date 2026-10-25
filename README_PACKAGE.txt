OmniViewCTF - Caster Edition v2.2
====================================

Edit by ToastyCL
Released: 25 October 2026

ABOUT
-----
OmniViewCTF - Caster Edition is a broadcast-oriented spectator HUD for Unreal Tournament 99 CTF.

This package focuses on a cleaner caster layout, compact SmartCTF statistics, item timers, Player Cam, comparison tools, and improved spectator controls.

WHAT'S NEW IN v2.2
------------------
- Current weapon shown in the Spectating bar
- Live ammunition count when applicable
- Compact " | " separator between player and weapon information
- Ammo omitted for Impact Hammer, Translocator and Super Shock Rifle
- Automatic trimming for long player / weapon names
- Frameless Player Cam
- Team-colored player name inside Player Cam
- Smaller centered Player Cam crosshair
- Configurable View toggle key for BehindView 0 / 1
- Better lower HUD spacing and vertical centering
- Refined spectator bar and timer size
- Jump Boots display:
    Boots
    Boots 3 / Boots 2 / Boots 1 when charge is available
- Chat moved below RED scoreboard
- Kill feed below BLUE scoreboard
- Dedicated Say: typing row to avoid chat overlap
- Scoreboard supports more than five players per team
- Internal team capacity increased to 16 players per side
- FK replaces FCK
- Cleaner RED / BLUE headers

INSTALLATION
------------
Copy these files into your UnrealTournament\System folder:

- OmniViewCTF_CasterED.u
- OmniViewCTF_CasterED.int
- OmniViewCTF_CasterED.ini

Then start Unreal Tournament.

STARTING THE MOD
----------------
Open:

Mod -> OmniViewCTF - Caster Edition -> Start

Caster Edition does not use AutoStart.

RECOMMENDED KEYS
----------------
Open:

Mod -> OmniViewCTF - Caster Edition

Configure:

- Player Compare key
- MVP Focus key
- Player Cam key
- View toggle key

PLAYER CAM
----------
1. Spectate a player.
2. Press the configured Player Cam key.
3. The secondary camera locks to that player.
4. You can change your main spectator target without moving Player Cam.
5. Press the same key again to close it.

VIEW TOGGLE
-----------
The View toggle key switches the main spectator camera between:

BehindView 0
BehindView 1

WEAPON / AMMO
-------------
While spectating a player, the lower HUD shows the current weapon on the same line.

Example:

Spectating PlayerName [RED] | Flak Cannon 7

For weapons without a meaningful ammo counter:

Spectating PlayerName [RED] | Impact Hammer

The information updates automatically when the player changes weapon or ammunition changes.

SCOREBOARD
----------
Columns:

# | Player | CAP | GRB | FK | COV | SEA | FRG | EFF

The scoreboard supports up to 16 players per team.

CHAT / KILL FEED
----------------
- Chat is positioned below the RED scoreboard.
- Kill feed is positioned below the BLUE scoreboard.
- Say: has a dedicated row.
- The positions automatically follow the current team-table height.

JUMP BOOTS
----------
While spectating a player with Jump Boots:

Boots

is shown in the lower spectator HUD.

When the remaining replicated charge is available:

Boots 3
Boots 2
Boots 1

is shown instead.

FILES
-----
OmniViewCTF_CasterED.u
OmniViewCTF_CasterED.int
OmniViewCTF_CasterED.ini
README_PACKAGE.txt

CREDITS
-------
Original OmniView4CTF:
Waylander / double_u

Previous fork:
v1.1 rX edit

Caster Edition development:
ToastyCL

Please preserve the original credits and fork history when redistributing modified versions.
