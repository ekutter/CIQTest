using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

//---------------------------------------------------------
//---------------------------------------------------------
class PgHomeDelegate extends Ui.BehaviorDelegate
{
    //---------------------------------
    function onNextPage() {Sys.println("home.onNextPage");state.setPg(1);}     
    function onPreviousPage() {Sys.println("home.onPrevPage");state.setPg(-1);} 
    function onSwipe(evt)
    {
         var swipe  = evt.getDirection();
         Sys.println("home.onSwipe= " + swipe);
         return(false);
    }
    function onMenu() {Sys.println("Home.onMenu: - next page");state.setPg(2);} //for when onNextPage not getting called.
    function onKey(keyevt) 
    {
        var key = keyevt.getKey();
        Sys.println("home.onKey: " + key);
        switch (key)
        {
        case Ui.KEY_ENTER: state.setPg(3); return(true); //straight to the font page
        default:
            break;            
        }
        return(false);
    }
    function onKeyPressed(keyevt)
    {
        Sys.println("Home.onKeyPressed: " + keyevt.getKey());
    }
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
    var fFirstTime = true;
    function onUpdate(dc)
    {
        if (fFirstTime)
        {
            fFirstTime = false;
            Sys.println("Font getSize('1234567890')");
            for (var i = F0; i <= FN3; ++i)
            {
                Sys.println(i + " - " + dc.getTextDimensions("1234567890",i));
            }
        }
    
        dc.setColor(ClrBG,ClrBG);
        dc.clear();

        var settings = Sys.getDeviceSettings();
        var stats = Sys.getSystemStats();
        var s;

        var y = 4;
        fillRect(dc,0,0,cxScreen,FntAscent[F4],ClrYellow);
        y += drawTextY(dc,xCenter,y,F4,"Home2",JC,ClrFG);

        y += drawTextY(dc,xCenter,y,F2,strBench,JC,ClrFG);

        s = Lang.format("p#: $1$", [settings.partNumber]); 
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrFG);

        s = Lang.format("id: $1$", [settings.uniqueIdentifier.substring(0,16)]); 
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrFG);
        
        s = Lang.format("mem: $1$k/$2$k - $3$k",
            [stats.usedMemory/1024, 
             stats.totalMemory/1024,
             stats.freeMemory/1024]);
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrFG);        

        var temp = "";
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getTemperatureHistory))
        {        
          var tempIter = Toybox.SensorHistory.getTemperatureHistory({:period => 1});
          temp = tempIter.next().data.format("%0.0f");
        }

        // settings.connectionAvailable, connectionInfo, phoneConnected
        // screenshape
        
        var ver = settings.monkeyVersion;
        s = Lang.format("fw$1$.$2$ CIQ$3$.$4$.$5$", 
            [settings.firmwareVersion[0],settings.firmwareVersion[1],
             ver[0],ver[1],ver[2]]); 
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrFG);        

        s = Lang.format("touch: $1$ btns: $2$", [settings.isTouchScreen ? "Y" : "N",settings.inputButtons]); 
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrFG);
        
        y += drawTextY(dc,xCenter,y,F2,Lang.format("dc: $1$,$2$",[dc.getWidth(), dc.getHeight()]),JC,ClrFG);
        if ((cxScreen != dc.getWidth()) || (cyScreen != dc.getHeight()))        
            {y += drawTextY(dc,xCenter,y,F2,Lang.format("scr: $1$,$2$",[cxScreen,cyScreen]),JC,ClrFG);}

        s = "bat: " + stats.battery.format("%0.0f");
        y += drawTextY(dc,xCenter,y,F2,s,JC,ClrFG);
        
    }
}