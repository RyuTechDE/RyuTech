state("Fusion")
{
	byte GameState: "Fusion.exe", 0x2A52D4, 0xC201;
	byte GameState2: "Fusion.exe", 0x2A52D4, 0xC200;
	short PointCount: "Fusion.exe", 0x2A52D4, 0xC820;
	byte Level100: "Fusion.exe", 0x2A52D4, 0xC832;
	byte LevelCount: "Fusion.exe", 0x2A52D4, 0xC833;
}

state("Gens")
{
	byte GameState: "Gens.exe", 0x40F5C, 0xC201;
	short PointCount: "Gens.exe", 0x40F5C, 0xC820;
	byte LevelCount: "Gens.exe", 0x40F5C, 0xC833; 
	byte Level100: "Gens.exe", 0x40F5C, 0xC833;
}

start
{
	return current.GameState == 0 && old.GameState == 3;
}

 

split
{
	
		return (settings["LevelSplit"] && old.LevelCount < current.LevelCount) || (settings["LevelSplit"] && old.Level100 == 0 && current.Level100 == 1) || (settings["PointSplit"] && current.PointCount > old.PointCount);

}

startup
{
    settings.Add("LevelSplit", true, "Splits at each Level");
    settings.Add("PointSplit", false, "Splits every 10K Points");
}