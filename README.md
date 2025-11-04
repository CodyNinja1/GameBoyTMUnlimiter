# GameBoyTMUnlimiter
Source code for a Game Boy (DMG only) emulator, written for TMUnlimiter (2.0.3). Its goal is to emulate Tetris (so far).

# Build
Put your ROM as an angelscript file named ROM.as in the project, in the following format:
```angelscript
const array<uint8> ROM = {
    0,
    1,
    255,
    // ...
    0,
    0
};
```
Then, use the following command to composite the ROM contents into the GameBoy file:
```batch
py compositor.py GameBoy.tmunlimiter.as
```
Make sure to restart your game before trying to load the new `c_GameBoy.tmunlimiter.as` file.