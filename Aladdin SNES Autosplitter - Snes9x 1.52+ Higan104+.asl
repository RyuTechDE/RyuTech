state("higan") {}
state("snes9x") {}
state("snes9x-x64") {}
state("emuhawk") {}

init
{
    var states = new Dictionary<int, long>
    {
        { 10330112, 0x789414 },     //snes9x 1.52-rr
        { 7729152, 0x890EE4 },      //snes9x 1.54-rr
        { 5914624, 0x6EFBA4 },      //snes9x 1.53
        { 6909952, 0x140405EC8 },   //snes9x 1.53 (x64)
        { 6447104, 0x7410D4 },      //snes9x 1.54/1.54.1
        { 7946240, 0x1404DAF18 },   //snes9x 1.54/1.54.1 (x64)
        { 6602752, 0x762874 },      //snes9x 1.55
        { 8355840, 0x1405BFDB8 },   //snes9x 1.55 (x64)
        { 6856704, 0x78528C },      //snes9x 1.56/1.56.2
        { 9003008, 0x1405D8C68 },   //snes9x 1.56 (x64)
        { 6848512, 0x7811B4 },      //snes9x 1.56.1
        { 8945664, 0x1405C80A8 },   //snes9x 1.56.1 (x64)
        { 9015296, 0x1405D9298 },   //snes9x 1.56.2 (x64)
        { 6991872, 0x7A6EE4 },      //snes9x 1.57
        { 9048064, 0x1405ACC58 },   //snes9x 1.57 (x64)
        { 7000064, 0x7A7EE4 },      //snes9x 1.58
        { 9060352, 0x1405AE848 },   //snes9x 1.58 (x64)
        { 8953856, 0x975A54 },      //snes9x 1.59.2
        { 12537856, 0x1408D86F8 },  //snes9x 1.59.2 (x64)
        { 9027584, 0x94DB54 },      //snes9x 1.60
        { 12836864, 0x1408D8BE8 },  //snes9x 1.60 (x64)
        { 12509184, 0x915304 },     //higan v102
        { 13062144, 0x937324 },     //higan v103
        { 15859712, 0x952144 },     //higan v104
        { 16756736, 0x94F144 },     //higan v105tr1
        { 16019456, 0x94D144 },     //higan v106
        { 10096640, 0x72BECC },     //bsnes v107
        { 10338304, 0x762F2C },     //bsnes v107.1
        { 47230976, 0x765F2C },     //bsnes v107.2/107.3
        { 7061504, 0x36F11500240 }, //BizHawk 2.3
        { 7249920, 0x36F11500240 }, //BizHawk 2.3.1
    };

    long memoryOffset;
    if (states.TryGetValue(modules.First().ModuleMemorySize, out memoryOffset))
        if (memory.ProcessName.ToLower().Contains("snes9x"))
            memoryOffset = memory.ReadValue<int>((IntPtr)memoryOffset);

    if (memoryOffset == 0)
        throw new Exception("Memory not yet initialized.");

    vars.watchers = new MemoryWatcherList
    {
        new MemoryWatcher<byte>((IntPtr)memoryOffset + 0x35E) { Name = "levelFrames" },
        new MemoryWatcher<byte>((IntPtr)memoryOffset + 0x15F) { Name = "playerSelect" },
        new MemoryWatcher<short>((IntPtr)memoryOffset + 0xC0C) { Name = "SnakeHit" },
        new MemoryWatcher<byte>((IntPtr)memoryOffset + 0x164) { Name = "someVar" },
        new MemoryWatcher<byte>((IntPtr)memoryOffset + 0x849) { Name = "menuItem" },
    };
}

update
{
    vars.watchers.UpdateAll(game);
}

start
{
    return vars.watchers["levelFrames"].Current == 0x00 && vars.watchers["someVar"].Old == 0x9F &&  vars.watchers["someVar"].Current == 0xA0 && vars.watchers["menuItem"].Current == 0x00;
}

split
{
    var StageTransition = vars.watchers["levelFrames"].Old < vars.watchers["levelFrames"].Current && vars.watchers["levelFrames"].Current != 0x30 && vars.watchers["levelFrames"].Current != 0x25;
    var SnakeKill = vars.watchers["levelFrames"].Current == 0x11 && vars.watchers["SnakeHit"].Current == 0xFF;

    return StageTransition || SnakeKill;
}
