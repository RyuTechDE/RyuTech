state("fceux")
{
	byte GameState: "fceux.exe", 0x3B1388, 0x00C0;
	byte Point1: "fceux.exe", 0x3B1388, 0x0073;
	byte Point100: "fceux.exe", 0x3B1388, 0x0074;
	byte Point10000: "fceux.exe", 0x3B1388, 0x0075;
	byte LineCount: "fceux.exe", 0x3B1388, 0x0070;
	byte Line100: "fceux.exe", 0x3B1388, 0x0071;
	byte LevelCount: "fceux.exe", 0x3B1388, 0x0067;
	byte ModeSelect: "fceux.exe", 0x3B1388, 0x00C1;
}

state("nestopia")
{
    // base address = 0x1b2bcc, 0, 8, 0xc, 0xc, 0x68;
	byte GameState: "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x128;		// 0x00C0;
	byte Point1: "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xDB; 			// 0x0073;
	byte Point100: "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xDC;  		// 0x0074;
	byte Point10000: "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xDD; 		// 0x0075;
	byte LineCount: "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xD8; 		// 0x0070;
	byte Line100: "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xD9;			// 0x0071; 
	byte LevelCount: "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xD5; 		// 0x0067;
	byte ModeSelect: "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x129; 		// 0x00C1;
}


state("mesen")
{
     // base address = 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 0x08,
  	byte GameState : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 0x08, 0x00C0;  // 0x00C0;
  	byte Point1 : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 0x08, 0x0073;  // 0x0073;
  	byte Point100 : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 0x08, 0x0074;   // 0x0074;
  	byte Point10000 : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 0x08, 0x0075;    // 0x0075;
  	byte LineCount : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 0x08, 0x0070;    // 0x0070;
  	byte Line100 : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 0x08, 0x0071;    // 0x0071; 
  	byte LevelCount : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 0x08, 0x0067;  // 0x0067;
  	byte ModeSelect : "MesenCore.dll", 0x4311838, 0x118, 0xB8, 0x90, 0x1D8, 0x08, 0x00C1;  // 0x00C1;
}

update

{
	if (current.LineCount != old.LineCount) {
  print(current.LineCount.ToString());
}
}

start
{
	return current.GameState == 0x04 && old.GameState == 0x03 && current.ModeSelect == 0x00;
}

split
{	
	bool result = false;
	
	if (settings["PointSplit"])
            {
                if (current.Point10000 > old.Point10000 && current.GameState == 0x04)
                    result = true;
			}
	if (settings["LineSplit"])		
			{
				if (current.Line100 >= 0x01 && current.GameState == 0x04)
					result = true;
			
				if(old.LineCount % 0x10 > current.LineCount % 0x10 && current.LineCount != 0x00)
					result = true;
			}		
	if (result)
			return true;
}

startup
{
    settings.Add("LineSplit", true, "Splits every 10 Lines until 100");
    settings.Add("PointSplit", false, "Splits every 10K Points until 990K");
}