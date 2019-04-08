using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

//---------------------------------------------------------
//---------------------------------------------------------
class PgHomeDelegate extends Ui.BehaviorDelegate
{
    //---------------------------------
    function onNextPage() {state.setPg(1);}     
    function onPreviousPage() {state.setPg(-1);} 
}

//---------------------------------------------------------
class PgHomeView extends Ui.View
{
	var strBench = "";
	function onShow()
	{
		Sys.println("onShow");
		var sw = new StopWatch();
		
		var x = 1;
		var acc = 124;
		for (var i = 0; i < 3000; ++i)
		{
			acc *= x;
		}
		strBench = sw.toStr();
		
		sw.initialize();
		x = 1.246;
		acc = 124;
		for (var i = 0; i < 3000; ++i)
		{
			acc *= x;
		}
		
		strBench += ", " + sw.toStr();
		
		
	}
    //---------------------------------
    function onUpdate(dc)
    {
        dc.setColor(ClrBlack,ClrBlack);
        dc.clear();

        var settings = Sys.getDeviceSettings();
        var stats = Sys.getSystemStats();
        var s;

        var y = 4;
        fillRect(dc,0,0,cxScreen,FntAscent[F4],ClrYellow);
        y += drawTextY(dc,xCenter,y,F4,"Home2",JC,ClrWhite);

        y += drawTextY(dc,xCenter,y,F2,strBench,JC,ClrWhite);

        s = Lang.format("p#: $1$", [settings.partNumber]); 
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrWhite);

        s = Lang.format("id: $1$", [settings.uniqueIdentifier.substring(0,16)]); 
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrWhite);
        
        s = Lang.format("mem: $1$k/$2$k - $3$k",
            [stats.usedMemory/1024, 
             stats.totalMemory/1024,
             stats.freeMemory/1024]);
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrWhite);        

        var temp = "";
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getTemperatureHistory))
        {        
          var tempIter = Toybox.SensorHistory.getTemperatureHistory({:period => 1});
          temp = tempIter.next().data.format("%0.0f");
        }

        s = "bat: " + stats.battery.format("%0.0f");
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrWhite);
        
        // settings.connectionAvailable, connectionInfo, phoneConnected
        // screenshape
        
        var ver = settings.monkeyVersion;
        s = Lang.format("fw: $1$.$2$ mnkyV: $3$.$4$.$5$", 
            [settings.firmwareVersion[0],settings.firmwareVersion[1],
             ver[0],ver[1],ver[2]]); 
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrWhite);        

        s = Lang.format("touch: $1$ btns: $2$", [settings.isTouchScreen ? "Y" : "N",settings.inputButtons]); 
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrWhite);
        
        y += drawTextY(dc,xCenter,y,F2,Lang.format("dc: $1$,$2$",[dc.getWidth(), dc.getHeight()]),JC,ClrWhite);
        if ((cxScreen != dc.getWidth()) || (cyScreen != dc.getHeight()))        
            {y += drawTextY(dc,xCenter,y,F2,Lang.format("scr: $1$,$2$",[cxScreen,cyScreen]),JC,ClrWhite);}
    }
}