state("bgb") {}
state("bgb64") {}
state("gambatte") {}
state("gambatte_qt") {}
state("gambatte_speedrun") {}

startup
{
    //-------------------------------------------------------------//
    settings.Add("stage", true, "Screen Transition Splits");
    settings.Add("noboss", false, "No Splitting before Bosses");
    settings.Add("stagepractice", false, "Practicing Stages Mode");
            settings.Add("onequarter", false, "Split at one quarter", "stagepractice");
            settings.Add("twoquarter", false, "Split at half", "stagepractice");
            settings.Add("threequarter", false, "Split at three quarters", "stagepractice");
    //-------------------------------------------------------------//

    vars.stopwatch = new Stopwatch();

    vars.timer_OnStart = (EventHandler)((s, e) =>
    {
        vars.splits = vars.GetSplitList();
    });
    timer.OnStart += vars.timer_OnStart;

    vars.FindOffsets = (Action<Process, int>)((proc, memorySize) =>
    {
		var wramPtrPath = new int[] {}; // List of offsets to WRAM
		var isGambatte = false;
		vars.wramOffset = IntPtr.Zero;
        switch (memorySize)
        {
            case 1691648: //bgb (1.5.1)
                wramPtrPath = new int[] { 0x55BC7C, 0x34, 0xC0 };
				vars.wramOffset += 0xC000;
                break;
            case 1699840: //bgb (1.5.2)
                wramPtrPath = new int[] { 0x55DCA0, 0x34, 0xC0 };
				vars.wramOffset += 0xC000;
                break;
            case 1736704: //bgb (1.5.3/1.5.4)
                wramPtrPath = new int[] { 0x564EBC, 0x34, 0xC0 };
				vars.wramOffset += 0xC000;
                break;
            case 1740800: //bgb (1.5.5/1.5.6)
                wramPtrPath = new int[] { 0x566EDC, 0x34, 0xC0 };
				vars.wramOffset += 0xC000;
                break;
            case 1769472: //BGB 1.5.7
                wramPtrPath = new int[] { 0x56CF14, 0x34, 0xC0 };
				vars.wramOffset += 0xC000;
                break;
            case 4632576: //BGB 1.5.7 (x64)
                wramPtrPath = new int[] { 0x803100, 0x34, 0xC0 };
				vars.wramOffset += 0xC000;
                break;
			case 4775936: //BGB 1.5.9 (x64)
				wramPtrPath = new int[] { 0x7B2928, 0x234 };
				vars.wramOffset += 0x0;
				break;
			case 14569472: //gambatte-speedrun (r717 psr)
				wramPtrPath = new int[] { 0x11D49E0, 0x5E0 };
				vars.wramOffset += 0x0;
				break;			
            case 14290944: //gambatte-speedrun (r600)
            case 14180352: //gambatte-speedrun (r604/r614)
	
				isGambatte = true;
				vars.wramOffset += 0x0;
                break;
			default:
				vars.wramOffset += 1; // Fallback value if none of the above are found
				break;
        }
		
		if(isGambatte)
		{
			if (vars.ptrOffset == IntPtr.Zero)
			{
				print("[Autosplitter] Scanning memory");
				var target = new SigScanTarget(0, "05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ?? ?? ?? ?? ?? ?? ?? ?? F8 00 00 00");

				var ptrOffset = IntPtr.Zero;
				foreach (var page in proc.MemoryPages())
				{
					var scanner = new SignatureScanner(proc, page.BaseAddress, (int)page.RegionSize);

					if ((ptrOffset = scanner.Scan(target)) != IntPtr.Zero)
						break;
				}

				vars.ptrOffset = ptrOffset;
				vars.wramPtr = new MemoryWatcher<int>(vars.ptrOffset - 0x20);
			}
		}
        else if(wramPtrPath.Length > 0)
        {
			if (vars.ptrOffset == IntPtr.Zero)
			{
				// Get value at pointer path
				var currentAddress = IntPtr.Zero;
				for(var i = 0; i < wramPtrPath.Length - 1; i++)
					currentAddress = proc.ReadPointer(currentAddress + wramPtrPath[i]);
				
				vars.ptrOffset = (IntPtr)currentAddress;
				vars.wramPtr = new MemoryWatcher<int>(vars.ptrOffset + wramPtrPath[wramPtrPath.Length - 1]);
			}
        }

		if (vars.ptrOffset != IntPtr.Zero)
		{
			vars.wramPtr.Update(proc);
			vars.wramOffset += vars.wramPtr.Current;
		}

		if (vars.wramOffset != IntPtr.Zero)
			print("[Autosplitter] WRAM: " + vars.wramOffset.ToString("X8"));
    });

    vars.GetWatcherList = (Func<IntPtr, MemoryWatcherList>)((wramOffset) =>
    {
        return new MemoryWatcherList
        {
			new MemoryWatcher<byte>(wramOffset + 0x008) { Name = "scene" },
            new MemoryWatcher<byte>(wramOffset + 0x880) { Name = "stage" },
            new MemoryWatcher<byte>(wramOffset + 0x881) { Name = "substage" },
            new MemoryWatcher<byte>(wramOffset + 0x882) { Name = "total" },
            new MemoryWatcher<byte>(wramOffset + 0x137) { Name = "crankdone1" },
            new MemoryWatcher<byte>(wramOffset + 0x138) { Name = "crankdone2" },
            new MemoryWatcher<byte>(wramOffset + 0xA8F) { Name = "stagelength" },
            new MemoryWatcher<byte>(wramOffset + 0xC95) { Name = "stagepositionx" },
        };
    });

    vars.GetSplitList = (Func<List<Tuple<string, List<Tuple<string, int>>>>>)(() =>
    {
        return new List<Tuple<string, List<Tuple<string, int>>>>
        {
        };
    });
}

init
{
    vars.ptrOffset = IntPtr.Zero;
    vars.wramOffset = IntPtr.Zero;

    vars.wramPtr = new MemoryWatcher<byte>(IntPtr.Zero);

    vars.watchers = new MemoryWatcherList();
    vars.splits = new List<Tuple<string, List<Tuple<string, int>>>>();

    vars.stopwatch.Restart();
}

update
{
    if (vars.stopwatch.ElapsedMilliseconds > 1500)
    {
        vars.FindOffsets(game, modules.First().ModuleMemorySize);

        if (vars.wramOffset != IntPtr.Zero)
        {
            vars.watchers = vars.GetWatcherList(vars.wramOffset);
            vars.stopwatch.Reset();
        }
        else
        {
            vars.stopwatch.Restart();
            return false;
        }
    }
    else if (vars.watchers.Count == 0)
        return false;

    vars.wramPtr.Update(game);

    if (vars.wramPtr.Changed)
    {
        vars.FindOffsets(game, modules.First().ModuleMemorySize);
        vars.watchers = vars.GetWatcherList(vars.wramOffset);
    }

    vars.watchers.UpdateAll(game);
}

start
{
    
        return vars.watchers["scene"].Current == 0x04 && vars.watchers["scene"].Old != 0x04;
    
}

reset
{
    if (settings["stagepractice"] && (vars.watchers["total"].Current < vars.watchers["total"].Old))
        return true;
}

split
{
    var result = false;
    var _stage = 0;
    var _substage = 0;
    var _stagelength = vars.watchers["stagelength"].Current;
    if (settings["stage"] && vars.watchers["total"].Old != 0x0F)
        {
        result = (vars.watchers["substage"].Current > vars.watchers["substage"].Old) || ((vars.watchers["stage"].Current > vars.watchers["stage"].Old) && (vars.watchers["substage"].Old != 0));
            if (settings["noboss"]) {
                _stage = vars.watchers["stage"].Current;
                _substage = vars.watchers["substage"].Current;
                switch (_stage) {
                    case 1:
                        if (_substage == 4)
                            result = false;
                        break;
                    case 2:
                    case 4:
                    case 5:
                        if (_substage == 2)
                            result = false;
                        break;
                    case 3:
                        if (_substage == 1)
                            result = false;
                        break;
                    default:
                        break;
                }
            }
        }
    if ((vars.watchers["total"].Current == 0x0F) && (vars.watchers["crankdone1"].Old < 0x09) && (vars.watchers["crankdone1"].Current == 0x09) && (vars.watchers["crankdone2"].Current == 0x00))
        result = true;
    if (settings["stagepractice"])
    {
        if (settings["onequarter"] && !result)
        {
            if (vars.watchers["stagepositionx"].Current > vars.watchers["stagepositionx"].Old)
            {
                if (vars.watchers["stagepositionx"].Current == ((_stagelength * 1) / 4))
                    result = true;
            }
        }
        if (settings["twoquarter"] && !result)
        {
            if (vars.watchers["stagepositionx"].Current > vars.watchers["stagepositionx"].Old)
            {
                if (vars.watchers["stagepositionx"].Current == ((_stagelength * 2) / 4))
                    result = true;
            }
        }
        if (settings["threequarter"] && !result)
        {
            if (vars.watchers["stagepositionx"].Current > vars.watchers["stagepositionx"].Old)
            {
                if (vars.watchers["stagepositionx"].Current == ((_stagelength * 3) / 4))
                    result = true;
            }
        }
    }
    if ((vars.watchers["stage"].Current > 0x05) || (vars.watchers["substage"].Current > 0x05) || (vars.watchers["total"].Current > 0x20))
        result = false;
    if (result)
        return true;
}

shutdown
{
    timer.OnStart -= vars.timer_OnStart;
}
