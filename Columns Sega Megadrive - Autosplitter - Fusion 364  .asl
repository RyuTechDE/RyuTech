state("Fusion")
{
	short GameState: "Fusion.exe", 0x2A52D4, 0xC200;
	short PointCount: "Fusion.exe", 0x2A52D4, 0xC820;
	short LevelCount: "Fusion.exe", 0x2A52D4, 0xC832;
}

state("Gens")
{
	short GameState: "Gens.exe", 0x40F5C, 0xC200;
	short PointCount: "Gens.exe", 0x40F5C, 0xC820;
	short LevelCount: "Gens.exe", 0x40F5C, 0xC832; 
}

start
{
	return current.GameState == 3 && old.GameState == 771;
}

 

split
{
	
		return (settings["LevelSplit"] && old.LevelCount < current.LevelCount) || (settings["PointSplit"] && current.PointCount > old.PointCount);

}

startup
{
    settings.Add("LevelSplit", true, "Splits at each Level");
    settings.Add("PointSplit", false, "Splits every 10K Points");
}