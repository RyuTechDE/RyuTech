state("visualboyadvance-m", "v2.14x32")
{
    byte levelFrames: "visualboyadvance-m.exe", 0x0308B7A8, 0x5C0;
	byte SnakeHit: "visualboyadvance-m.exe", 0x0308B7A8, 0x5810;
	byte someVar: "visualboyadvance-m.exe", 0x0308B7A8, 0x624;
	byte menuItem: "visualboyadvance-m.exe", 0x0308B7A8, 0x51A6;
	byte Cutscene: "visualboyadvance-m.exe", 0x0308B7A8, 0x479F;
}
state("visualboyadvance-m", "v2.14x64")
{
    byte levelFrames: "visualboyadvance-m.exe", 0x03839C00, 0x5C0;
	byte SnakeHit: "visualboyadvance-m.exe", 0x03839C00, 0x5810;
	byte someVar: "visualboyadvance-m.exe", 0x03839C00, 0x624;
	byte menuItem: "visualboyadvance-m.exe", 0x03839C00, 0x51A6;
	byte Cutscene: "visualboyadvance-m.exe", 0x03839C00, 0x479F;
}
state("mgba", "v0.7.3x32")
{
	byte levelFrames: "mGBA.exe", 0x0209D344, 0x18, 0x3C, 0x208, 0x4, 0x18, 0x5C0;
	byte SnakeHit: "mGBA.exe", 0x0209D344, 0x18, 0x3C, 0x208, 0x4, 0x18, 0x5810;
	byte someVar: "mGBA.exe", 0x0209D344, 0x18, 0x3C, 0x208, 0x4, 0x18, 0x624;
	byte menuItem: "mGBA.exe", 0x0209D344, 0x18, 0x3C, 0x208, 0x4, 0x18, 0x51A6;
	byte Cutscene: "mGBA.exe", 0x0209D344, 0x18, 0x3C, 0x208, 0x4, 0x18, 0x479F;
}
state("mgba", "v0.7.3x64")
{
	byte levelFrames: "mGBA.exe", 0x02314F88, 0x20, 0x58, 0x8, 0x30, 0x5C0;
	byte SnakeHit: "mGBA.exe", 0x02314F88, 0x20, 0x58, 0x8, 0x30, 0x5810;
	byte someVar: "mGBA.exe", 0x02314F88, 0x20, 0x58, 0x8, 0x30, 0x624;
	byte menuItem: "mGBA.exe", 0x02314F88, 0x20, 0x58, 0x8, 0x30, 0x51A6;
	byte Cutscene: "mGBA.exe", 0x02314F88, 0x20, 0x58, 0x8, 0x30, 0x479F;
}
state("no$gba", "v2.9b")
{
    byte levelFrames: "no$gba.exe", 0x94408, 0x95D4, 0x5C0;
	byte SnakeHit: "no$gba.exe", 0x94408, 0x95D4, 0x5810;
	byte someVar: "no$gba.exe", 0x94408, 0x95D4, 0x624;
	byte menuItem: "no$gba.exe", 0x94408, 0x95D4, 0x51A6;
	byte Cutscene: "no$gba.exe", 0x94408, 0x95D4, 0x479F;
}
state("higan", "v106")
{
	byte levelFrames: "higan.exe", 0xD7FB68;
	byte SnakeHit: "higan.exe", 0xD84DB8;
	byte someVar: "higan.exe", 0xD7FBCC;
	byte menuItem: "higan.exe", 0xD8474E;
	byte Cutscene: "higan.exe", 0xD83D47;
}
state("emuhawk", "v2.3.2")
{
	byte levelFrames: "mgba.dll", 0x0E7460, 0x10, 0x18, 0x1E8, 0x30, 0x5C0;
	byte SnakeHit: "mgba.dll", 0x0E7460, 0x10, 0x18, 0x1E8, 0x30, 0x5810;
	byte someVar: "mgba.dll", 0x0E7460, 0x10, 0x18, 0x1E8, 0x30, 0x624;
	byte menuItem: "mgba.dll", 0x0E7460, 0x10, 0x18, 0x1E8, 0x30, 0x51A6;
	byte Cutscene: "mgba.dll", 0x0E7460, 0x10, 0x18, 0x1E8, 0x30, 0x479F;
}


//	state("emuhawk", "v2.3.2vba")
//	{
//		byte levelFrames: "libvbanext.dll", -0x000009D0, 0x18, 0x0, 0x8, 0xB20, 0x0, 0x8, 0x40, 0x5C0;
//		byte SnakeHit: "libvbanext.dll", -0x000009D0, 0x18, 0x0, 0x8, 0xB20, 0x0, 0x8, 0x40, 0x5810;
//		byte someVar: "libvbanext.dll", -0x000009D0, 0x18, 0x0, 0x8, 0xB20, 0x0, 0x8, 0x40, 0x624;
//		byte menuItem: "libvbanext.dll", -0x000009D0, 0x18, 0x0, 0x8, 0xB20, 0x0, 0x8, 0x40, 0x51A6;
//		byte Cutscene: "libvbanext.dll", -0x000009D0, 0x18, 0x0, 0x8, 0xB20, 0x0, 0x8, 0x40, 0x479F;
//	}


init
{
    if (modules.First().ModuleMemorySize == 0x4480000)
        version = "v2.14x64";
    else if (modules.First().ModuleMemorySize == 0x3FE7000)
        version = "v2.14x32";
	else if (modules.First().ModuleMemorySize == 0x69E000)
		version = "v2.3.2";
	else if (modules.First().ModuleMemorySize == 0x24D5000)
        version = "v0.7.3x32";
	else if (modules.First().ModuleMemorySize == 0x26BB000)
        version = "v0.7.3x64";
	else if (modules.First().ModuleMemorySize == 0x138000)
        version = "v2.9b";
	else if (modules.First().ModuleMemorySize == 0xEA6000)
        version = "v106";
}

update
{
	print(current.Cutscene.ToString());
}

start
{
		var	Djini = old.Cutscene == 0x13 
			&& current.menuItem == 0x00
			&& current.Cutscene == 0x01;
		var	Lamp = old.Cutscene == 0x14 
			&& current.menuItem == 0x00
			&& current.Cutscene == 0x01;
    return Djini || Lamp;
}

 

split
{
    var StageTransition = old.levelFrames < current.levelFrames
			&& current.levelFrames != 0x30 		// Cutscenes
			&& current.levelFrames != 0x25 		// Continue Screen
			&& current.levelFrames != 0x1D		// Hidden Bonus Stage
			&& current.levelFrames != 0x40		// MenuCutscene1
			&& current.levelFrames != 0x35		// MenuCutscene2
			&& old.levelFrames != 0x1D;
	var Stage14 = old.levelFrames == 0x1E 
			&& current.levelFrames == 0x03;
	var Stage22 = old.levelFrames == 0x1F 
			&& current.levelFrames == 0x05;
	var	Stage32 = old.levelFrames == 0x20 
			&& current.levelFrames == 0x07;
	var	Stage41 = old.levelFrames == 0x21 
			&& current.levelFrames == 0x08;
	var	Stage52 = old.levelFrames == 0x22 
			&& current.levelFrames == 0x0C;
	var	Stage6B = old.levelFrames == 0x12 
			&& current.levelFrames == 0x0E;
	var	Stage62 = old.levelFrames == 0x23 
			&& current.levelFrames == 0x0F;
	var SnakeKill = current.levelFrames == 0x11 
			&& current.SnakeHit == 0xFF;
	
    return StageTransition || SnakeKill || Stage14 || Stage22 || Stage32 || Stage41 || Stage52 || Stage6B || Stage62;
}

startup
{

}