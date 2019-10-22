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
init
{
    if (modules.First().ModuleMemorySize == 0x4480000)
        version = "v2.14x64";
    else if (modules.First().ModuleMemorySize == 0x3FE7000)
        version = "v2.14x32";
}

update
{
	print(current.levelFrames.ToString());
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
			&& current.levelFrames != 0x30 
			&& current.levelFrames != 0x25 
			&& current.levelFrames != 0x1D
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