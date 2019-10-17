state("Fusion")
{
	byte GameState: "Fusion.exe", 0x2A52D4, 0x448;
	byte StartGame: "Fusion.exe", 0x2A52D4, 0x449;
	byte WinCount: "Fusion.exe", 0x2A52D4, 0x44A;
	byte SomeVar: "Fusion.exe", 0x2A52D4, 0x435;
	byte NotStageCount: "Fusion.exe", 0x2A52D4, 0x4001;
}

state("Gens")
{
	byte GameState: "Gens.exe", 0x40F5C, 0x448;
	short StartGame: "Gens.exe", 0x40F5C, 0x449;
	byte WinCount: "Gens.exe", 0x40F5C, 0x44A; 
	byte SomeVar: "Gens.exe", 0x40F5C, 0x435;
}

start
{
	return (settings["Normal"] && current.GameState == 1 && current.NotStageCount == 1);
	return (settings["Hard"] && current.GameState == 2 && current.NotStageCount == 1);
}

 

split
{
	
		return (old.WinCount == 2 && current.WinCount == 0 && old.SomeVar == 1 && current.SomeVar == 0);

}

startup
{
    settings.Add("Normal", false, "Splits on Normal Mode");
    settings.Add("Hard", true, "Splits on Hard Mode");
}