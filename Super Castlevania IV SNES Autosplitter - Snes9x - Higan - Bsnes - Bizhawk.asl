state("higan") {}
state("snes9x") {}
state("snes9x-x64") {}
state("emuhawk") {}
state("bsnes") {}

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
        { 15360000, 0x8AB144 },     //higan v106, old offset(0x94D144), filesize(16019456)
        { 10096640, 0x72BECC },     //bsnes v107
        { 10338304, 0x762F2C },     //bsnes v107.1
        { 47230976, 0x765F2C },     //bsnes v107.2/107.3
		{ 131354624, 0xA6ED5C },	//bsnes v109
		{ 51924992, 0xA9DD5C }, 	//bsnes v111.3
		{ 52056064, 0xAAED7C }, 	//bsnes v112
        { 7061504, 0x36F11500240 }, //BizHawk 2.3
        { 7249920, 0x36F11500240 }, //BizHawk 2.3.1
		{ 6938624, 0x36F11500240 }, //BizHawk 2.3.2
		}; 

    long memoryOffset;
    if (states.TryGetValue(modules.First().ModuleMemorySize, out memoryOffset))
        if (memory.ProcessName.ToLower().Contains("snes9x"))
            memoryOffset = memory.ReadValue<int>((IntPtr)memoryOffset);

    if (memoryOffset == 0)
        throw new Exception("Memory not yet initialized.");

    vars.watchers = new MemoryWatcherList
    {
        new MemoryWatcher<byte>((IntPtr)memoryOffset + 0x86) { Name = "levelFrames" },
        new MemoryWatcher<byte>((IntPtr)memoryOffset + 0x64) { Name = "RegainControl" },
        new MemoryWatcher<short>((IntPtr)memoryOffset + 0x32) { Name = "GameState" },
        new MemoryWatcher<byte>((IntPtr)memoryOffset + 0x76) { Name = "OrbTimer" },
        new MemoryWatcher<byte>((IntPtr)memoryOffset + 0x72) { Name = "OrbReq" },
    };
}

update
{
    vars.watchers.UpdateAll(game);
	print(vars.watchers["GameState"].Current.ToString()); // Should turn to 4 when you are ingame.
}

startup
{
    settings.Add("Substages", false, "Splits all Substages (No automatic undo)");
	settings.Add("PreBoss", false, "Splits after each Boss in B-3 before Dracula");
} 

start
{
    return vars.watchers["levelFrames"].Current == 0x00 && vars.watchers["GameState"].Current == 0x04 &&  vars.watchers["RegainControl"].Current == 0x00 && vars.watchers["RegainControl"].Old == 0x01;
}

split
{
    var Stage11 = vars.watchers["levelFrames"].Old == 0x01 && vars.watchers["levelFrames"].Current == 0x02 && settings["Substages"];
	var Stage12 = vars.watchers["levelFrames"].Old == 0x04 && vars.watchers["levelFrames"].Current == 0x05 && settings["Substages"];
	var Stage13 = vars.watchers["levelFrames"].Old == 0x07 && vars.watchers["levelFrames"].Current == 0x08;
	var Stage21 = vars.watchers["levelFrames"].Old == 0x08 && vars.watchers["levelFrames"].Current == 0x09 && settings["Substages"];
	var Stage22 = vars.watchers["levelFrames"].Old == 0x09 && vars.watchers["levelFrames"].Current == 0x0A && settings["Substages"];
	var Stage23 = vars.watchers["levelFrames"].Old == 0x0B && vars.watchers["levelFrames"].Current == 0x0C;
	var Stage31 = vars.watchers["levelFrames"].Old == 0x0C && vars.watchers["levelFrames"].Current == 0x0D && settings["Substages"];
	var Stage32 = vars.watchers["levelFrames"].Old == 0x0D && vars.watchers["levelFrames"].Current == 0x0E && settings["Substages"];
	var Stage33 = vars.watchers["levelFrames"].Old == 0x11 && vars.watchers["levelFrames"].Current == 0x12;
	var Stage41 = vars.watchers["levelFrames"].Old == 0x14 && vars.watchers["levelFrames"].Current == 0x15 && settings["Substages"];
	var Stage42 = vars.watchers["levelFrames"].Old == 0x15 && vars.watchers["levelFrames"].Current == 0x16 && settings["Substages"];
	var Stage43 = vars.watchers["levelFrames"].Old == 0x16 && vars.watchers["levelFrames"].Current == 0x17 && settings["Substages"];
	var Stage44 = vars.watchers["levelFrames"].Old == 0x17 && vars.watchers["levelFrames"].Current == 0x18;
	var Stage51 = vars.watchers["levelFrames"].Old == 0x18 && vars.watchers["levelFrames"].Current == 0x19 && settings["Substages"];
	var Stage52 = vars.watchers["levelFrames"].Old == 0x19 && vars.watchers["levelFrames"].Current == 0x1A;
	var Stage61 = vars.watchers["levelFrames"].Old == 0x1C && vars.watchers["levelFrames"].Current == 0x1D && settings["Substages"];
	var Stage62 = vars.watchers["levelFrames"].Old == 0x1E && vars.watchers["levelFrames"].Current == 0x1F && settings["Substages"];
	var Stage63 = vars.watchers["levelFrames"].Old == 0x22 && vars.watchers["levelFrames"].Current == 0x23;
	var Stage71 = vars.watchers["levelFrames"].Old == 0x25 && vars.watchers["levelFrames"].Current == 0x26 && settings["Substages"];
	var Stage72 = vars.watchers["levelFrames"].Old == 0x29 && vars.watchers["levelFrames"].Current == 0x2A;
	var Stage81 = vars.watchers["levelFrames"].Old == 0x2B && vars.watchers["levelFrames"].Current == 0x2C && settings["Substages"];
	var Stage82 = vars.watchers["levelFrames"].Old == 0x2D && vars.watchers["levelFrames"].Current == 0x2E;
	var Stage91 = vars.watchers["levelFrames"].Old == 0x30 && vars.watchers["levelFrames"].Current == 0x31 && settings["Substages"];
	var Stage92 = vars.watchers["levelFrames"].Old == 0x36 && vars.watchers["levelFrames"].Current == 0x37;
	var StageA1 = vars.watchers["levelFrames"].Old == 0x3A && vars.watchers["levelFrames"].Current == 0x3B && settings["Substages"];
	var StageA2 = vars.watchers["levelFrames"].Old == 0x3B && vars.watchers["levelFrames"].Current == 0x3C;
	var StageB1 = vars.watchers["levelFrames"].Old == 0x3D && vars.watchers["levelFrames"].Current == 0x3E && settings["Substages"];
	var StageB2 = vars.watchers["levelFrames"].Old == 0x3E && vars.watchers["levelFrames"].Current == 0x3F && settings["Substages"];
	var StageB2A = vars.watchers["levelFrames"].Old == 0x3F && vars.watchers["levelFrames"].Current == 0x40 && settings["PreBoss"];
	var StageB2B = vars.watchers["levelFrames"].Old == 0x40 && vars.watchers["levelFrames"].Current == 0x41 && settings["PreBoss"];
	var StageB3 = vars.watchers["levelFrames"].Old == 0x41 && vars.watchers["levelFrames"].Current == 0x42 && settings["Substages"];
	var DraculaOrb = vars.watchers["levelFrames"].Current == 0x43 
		&& vars.watchers["OrbReq"].Current == 0x01 
		&& vars.watchers["OrbTimer"].Current == 0xFF;

    return Stage11 || Stage12 || Stage13 || Stage21 || Stage22 || Stage23 || Stage31 || Stage32 || Stage33 || Stage41 || Stage42 || Stage43 || Stage44 || Stage51 || Stage52 || Stage61 || Stage62 || Stage63 || Stage71 || Stage72 || Stage81 || Stage82 || Stage91 || Stage92 || StageA1 || StageA2 || StageB1 || StageB2 || StageB2A || StageB2B || StageB3 || DraculaOrb;
}

