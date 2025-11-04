//! COMPOSE ROM.as


const int Width = 161;
const int Height = 145;

class GameBoy_t
{
    array<uint8> Memory;
    MediaTrackerTrack@ TrianglesTrack;

    GameBoy_t()
    {
        for (uint Idx = 0; Idx <= 0x10000; Idx++)
        {
            Memory.add(ROM[Idx]);
        }
    }

    int GetIdx(int x, int y)
    {
        return (Width * y) + x;
    }

    void SetPixelColor(int x, int y, Color Col)
    {
        TrianglesTrack.blocks[0].triangles_setVertexColor(GetIdx(x + 0, y + 0), Col);
        if (x + 1 < Width and y + 1 < Height)
        {
            TrianglesTrack.blocks[0].triangles_setVertexColor(GetIdx(x + 1, y + 0), Col);
            TrianglesTrack.blocks[0].triangles_setVertexColor(GetIdx(x + 0, y + 1), Col);
            TrianglesTrack.blocks[0].triangles_setVertexColor(GetIdx(x + 1, y + 1), Col);
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
    else if ((WantToRead & 0b00010000) == 0b00010000)
    {
        uint8 Left = Vehicle.inputSteer < 0 ? 0 : 1;
        Left <<= 1;
        uint8 Right = Vehicle.inputSteer > 0 ? 0 : 1;
        // Right <<= 0;

        GameBoy.Memory[0xFF00] |= Left | Right;
    }
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
    @GameBoy.TrianglesTrack = Track;
}