//! COMPOSE ROM.as

//! COMPOSE ASCII.as

//! COMPOSE Instructions.as


const int Width = 160;
const int Height = 144;

const array<Color> ColorPallette =
{
    Color(0.094, 0.157, 0.031, 1.0), // #182808
    Color(0.157, 0.251, 0.125, 1.0), // #284020
    Color(0.282, 0.408, 0.188, 1.0), // #486830
    Color(0.533, 0.627, 0.282, 1.0)  // #88a048
};

class GameBoy_t
{
    array<uint8> Memory;
    PlugBitmap Screen(Width, Height);
    bool CanRun = true;
    array<Instruction> Instructions;

    uint16 AF = 0;
    uint16 BC = 0;
    uint16 DE = 0;
    uint16 HL = 0;

    uint16 StackPointer = 0;
    uint16 ProgramCounter = 0x0100;

    void CheckROMValidity()
    {
        if (Memory[0x0143] == 0xC0)
        {
            console.error("This script does not support GameBoy Color (CGB) ROMs.");
            CanRun = false;
            return;
        }

        if (Memory[0x0147] != 0x00)
        {
            console.error("This script only supports RAW ROMs with no MBCs.");
            CanRun = false;
            return;
        }

        if (Memory[0x0148] != 0x00)
        {
            console.error("This script does not support Banked ROMs.");
            CanRun = false;
            return;
        }

        if (Memory[0x0149] != 0x00)
        {
            console.error("This script does not support on-cartridge RAM.");
            CanRun = false;
            return;
        }

        uint8 HeaderChecksum = 0;
        for (uint16 Address = 0x0134; Address <= 0x014C; Address++) 
        {
            HeaderChecksum = HeaderChecksum - Memory[Address] - 1;
        }
        if (HeaderChecksum != Memory[0x014D])
        {
            console.error("Header checksum of ROM failed.");
            CanRun = false;
            return;
        }
    }

    GameBoy_t()
    {
        Screen.set_texFilter(TexFilter::Point);

        // From: Instructions.as
        Instructions = InitInstructions();

        // Note that this all happens at compiletime, not runtime
        for (uint Address = 0; Address <= 0x10000; Address++)
        {
            if (Address >= Cartridge.length)
            {
                Memory.add(0);
            }
            else
            {
                // Cartridge - From: ROM.as
                Memory.add(Cartridge[Address]);
            }
        }
        
        CheckROMValidity();

        string GameName = "";
        for (uint16 NameAddr = 0x0134; NameAddr < 0x0143; NameAddr++)
        {
            // ASCII - From: ASCII.as
            GameName = GameName + ASCII[Memory[NameAddr]];
        }
        console.info("Game name: " + GameName);
    }

    int GetIdx(int x, int y)
    {
        return (Width * y) + x;
    }

    void SetPixelColor(uint16 x, uint16 y, Color Col)
    {
        if (x >= Width or y >= Height) return;
        Screen.setPixel(x, y, Col);
    }

    void BlitTileToScreen(uint16 x, uint16 y, uint8 TileId, bool CheckLCDC)
    {
        uint16 BaseAddr = 0x8000;
        if (CheckLCDC)
        {
            uint8 LCDC = Memory[0xFF40];
            if ((LCDC & 0b00010000) != 0b00010000)
            {
                BaseAddr = 0x8800;
            }
            // else BaseAddr = 0x8000;
        }

        uint16 TileAddr = BaseAddr | (uint16(TileId) << 16);

        for (uint8 ByteIdx = 0; ByteIdx < 0xF; ByteIdx += 2)
        {
            uint8 Byte1 = Memory[TileAddr + ByteIdx + 1];
            uint8 Byte2 = Memory[TileAddr + ByteIdx];
            
            for (uint8 Bit = 1; Bit <= 8; Bit++)
            {
                uint8 RealBit = Bit - 1;
                uint8 Bit1 = Byte1 & (1 << RealBit);
                uint8 Bit2 = Byte2 & (1 << RealBit);

                Bit1 >>= RealBit;
                Bit2 >>= RealBit;

                SetPixelColor(x + 7 - RealBit, y + 7 - ByteIdx / 2, ColorPallette[(Bit1 << 1) | Bit2]);
            }
        }
    }

    uint8 GetTileIdFromTileMap(uint8 x, uint8 y, uint8 TileMapIdx)
    {
        // x <<= 0;
        y <<= 5;
        TileMapIdx <<= 10;

        return Memory[0b1001100000000000 | TileMapIdx | y | x];
    }

    void Render()
    {
        // Normally, we need to handle WX and WY
        // But Tetris always has them at 0, 0
        for (uint16 x = 0; x <= 19; x++)
        {
            for (uint16 y = 0; y <= 15; y++)
            {
                BlitTileToScreen(x * 8, y * 8, GetTileIdFromTileMap(x, y, 0), false);
            }
        }
    }
}

GameBoy_t GameBoy();

void onTick(TrackManiaRace@ Race)
{
    auto Vehicle = Race.getPlayingPlayer().vehicleCar;
    
    uint8 WantToRead = GameBoy.Memory[0xFF00] & 0xF0;

    if ((WantToRead & 0b00100000) == 0b00100000)
    {
        // 0 = pressed, 1 = down
        uint8 Up = Vehicle.inputGas == 1 ? 0 : 1;
        Up <<= 2;
        uint8 Down = Vehicle.inputBrake == 1 ? 0 : 1;
        Down <<= 3;
        // A and B are in onBindInputEvent because they use action keys

        GameBoy.Memory[0xFF00] |= Up | Down;
    }
    if ((WantToRead & 0b00010000) == 0b00010000)
    {
        uint8 Left = Vehicle.inputSteer < 0 ? 0 : 1;
        Left <<= 1;
        uint8 Right = Vehicle.inputSteer > 0 ? 0 : 1;
        // Right <<= 0;

        GameBoy.Memory[0xFF00] |= Left | Right;
    }

    // This is needed to let the screen update.
    GameBoy.Screen.setDirty();
}

void onFrame(TrackManiaRace@ race, GameCamVal& camVal)
{
    GameBoy.Render();
}

bool onBindInputEvent(TrackManiaRace@ race, BindInputEvent@ inputEvent, uint eventTime)
{   
    uint8 WantToRead = GameBoy.Memory[0xFF00] & 0xF0;
    if ((WantToRead & 0b00100000) == 0b00100000)
    {
        if (inputEvent.getBindName() == "TMUnlimiter - Action Key 1")
        {
            uint8 A = inputEvent.getEnabled() ? 0 : 1;
            // A <<= 0;

            GameBoy.Memory[0xFF00] |= A;   
        }
        if (inputEvent.getBindName() == "TMUnlimiter - Action Key 2")
        {
            uint8 B = inputEvent.getEnabled() ? 0 : 1;
            B <<= 1;

            GameBoy.Memory[0xFF00] |= B;   
        }
    }
    return false;
}

void onTriggerGroupEnter(TrackManiaRace@ Race, TriggerGroup@ triggerGroup, GameBlock@ triggerBlock)
{
    MediaTrackerClipPlayer@ InGamePlayer = Race.inGameClipPlayer;
    GameChallenge@ Map = Race.challenge;
    MediaTrackerClipGroup@ InGameClipGroup = Map.inGameClipGroup;
    auto Track = InGameClipGroup.clips[0].tracks[0];
    Track.blocks[0].image_setImage(GameBoy.Screen);
}