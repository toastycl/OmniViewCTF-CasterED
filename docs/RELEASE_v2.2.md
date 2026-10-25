# OmniViewCTF - Caster Edition v2.2

Released: **25 October 2026**

v2.2 adds live weapon information to the spectator HUD while keeping the compact single-line broadcast layout introduced in v2.1.

## What's new

- Current weapon displayed for the player being spectated
- Live ammunition count shown when applicable
- Compact ` | ` separator between player identity and weapon information
- Impact Hammer, Translocator and Super Shock Rifle shown without ammo count
- Automatic trimming for long player names or custom weapon names
- Existing FC / AMP / Boots / HP / Armor information preserved
- No changes to Player Cam, scoreboard logic, chat positioning or item timers

## Example

`Spectating PlayerName [RED] | Flak Cannon 7 | FC | AMP | Boots | HP | Armor`

## Runtime files

- `OmniViewCTF_CasterED.u`
- `OmniViewCTF_CasterED.int`
- `OmniViewCTF_CasterED.ini`

## Distribution

Recommended release assets:

- `OmniViewCTF_CasterED_v2.2.zip`
- `OmniViewCTF_CasterED.u`
- `OmniViewCTF_CasterED.int`
- `OmniViewCTF_CasterED.ini`

The ZIP should contain:

- `OmniViewCTF_CasterED.u`
- `OmniViewCTF_CasterED.int`
- `OmniViewCTF_CasterED.ini`
- `README.html` or `README_PACKAGE.txt`

## Upgrade

Replace the previous runtime files in your Unreal Tournament `System` folder with the v2.2 files and restart the game.

Caster Edition continues to use manual Start / Stop from:

**Mod -> OmniViewCTF - Caster Edition**

## Credits

Original OmniView4CTF by **Waylander / double_u**  
Previous fork: **v1.1 rX edit**  
Caster Edition development: **ToastyCL**
