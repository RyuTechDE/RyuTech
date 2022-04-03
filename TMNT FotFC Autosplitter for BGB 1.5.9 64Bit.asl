state("bgb64")
	// BGB version 1.5.9 64 Bit
{
	byte scene: 			"bgb64.exe", 0x3B2928, 0x234, 0x008;
	byte stage: 			"bgb64.exe", 0x3B2928, 0x234, 0x880;
	byte substage: 			"bgb64.exe", 0x3B2928, 0x234, 0x881;
	byte total: 			"bgb64.exe", 0x3B2928, 0x234, 0x882;
	byte crankdone1: 		"bgb64.exe", 0x3B2928, 0x234, 0x137;
	byte crankdone2: 		"bgb64.exe", 0x3B2928, 0x234, 0x138;
	byte stagelength: 		"bgb64.exe", 0x3B2928, 0x234, 0xA8F;
	byte stagepositionx: 	"bgb64.exe", 0x3B2928, 0x234, 0xC95;
}

startup
{
    //-------------------------------------------------------------//
			settings.Add("stage", true, "Standard");
			settings.Add("bosssplit", true, "Including Bosses");
			settings.Add("quarter", true, "Including Quarters");
    //-------------------------------------------------------------//
}

start
	// Starts after selecting your Turtle
{
	return current.scene == 0x04 && old.scene != 0x04;
}


split
{
	// Splits when Cranks reaches the middle of the screen after beeing beaten
	
	if 	(current.total == 0x0F && old.crankdone1 < 0x09 && current.crankdone1 == 0x09 && current.crankdone2 == 0x00)
				return true;
	
	// Refuses to split when entering and leaving Bonus Levels
	
    if (current.stage > 0x05 || current.substage > 0x05 || current.total > 0x20)
        return false;
	
	// Splits every 1/4 of a scene, on transitions and before bosses
	
	if (settings["quarter"])
        {
				
		if (current.stagepositionx > old.stagepositionx)
						{
							if (current.stagepositionx == ((current.stagelength * 1) / 4))
								return true;
							if (current.stagepositionx == ((current.stagelength * 2) / 4))
								return true;
							if (current.stagepositionx == ((current.stagelength * 3) / 4))
								return true;
						}
				
				return old.total != 0x0F && current.substage > old.substage
		|| 		current.stage > old.stage && old.substage != 0;
			
					
					         
        }
        
        
    // Splits on every transition and before bosses
	
	if (settings["bosssplit"]) 
			{
				return old.total != 0x0F && current.substage > old.substage
				|| 		current.stage > old.stage && old.substage != 0;
			}
	
	// Splits After Transitions but not before bosses
	
	if 	(settings["stage"])
					
			if (current.stage == 1)
				{
				return old.total != 0x0F && current.substage > old.substage && current.substage != 4
	|| 		current.stage > old.stage && old.substage != 0;
				}			
			if (current.stage == 2)
				{
				return old.total != 0x0F && current.substage > old.substage && current.substage != 2
	|| 		current.stage > old.stage && old.substage != 0;
				}		
			if (current.stage == 3)
				{
				return old.total != 0x0F && current.substage > old.substage && current.substage != 1
	|| 		current.stage > old.stage && old.substage != 0;
				}	
			if (current.stage == 4)
				{
				return old.total != 0x0F && current.substage > old.substage && current.substage != 2
	|| 		current.stage > old.stage && old.substage != 0;
				}	        
			if (current.stage == 5)
				{
				return old.total != 0x0F && current.substage > old.substage && current.substage != 2
	|| 		current.stage > old.stage && old.substage != 0;
				}					
}		








