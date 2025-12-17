## Notes

Thanks to Dennaton Games and Devolver Digital for creating Hotline Miami!

This port requires game files from the **Android version** of Hotline Miami.

## Installation

1. Download this port to your device's `ports/` folder
2. Obtain your Hotline Miami Android APK
3. Extract the APK using 7-Zip or similar tool
4. Copy files to the port:

### Option A: Use the APK directly
- Rename your APK to `game.port`
- Place it in the `hotlinemiami/` folder

### Option B: Use extracted assets
Copy from the APK's `assets/` folder to `hotlinemiami/assets/`:
- `game.droid` (required - main game data)
- `*.ogg` files (required - all audio/music files):
  - `hydrogen.ogg`, `hotline.ogg`, `crystals.ogg`, etc.

Copy from the APK's `lib/arm64-v8a/` folder to `hotlinemiami/lib/arm64-v8a/`:
- `libyoyo.so` (required - game runtime)

5. Launch via Portmaster

## Controls

| Button | Action |
|--------|--------|
| D-Pad / Left Analog | Movement |
| Right Analog | Aim |
| A | Attack |
| B | Use / Pickup |
| X | Lock Aim |
| Y | Restart Level |
| L1 | Previous Weapon |
| R2 | Throw Weapon |
| Start | Pause |
| Select | Show Score |

## Credits

- **Developer**: Dennaton Games
- **Publisher**: Devolver Digital
- **GMLoader-Next**: JohnnyonFlame
- **Port Template**: Doronimmo
