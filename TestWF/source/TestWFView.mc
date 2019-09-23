using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;


//global for 1hz
var do1hz=false;
var canDo1hz=true;

var cPartial = 0;
var cUpdate = 0;
var cBG = 0;


//-----------------------------------------------------------------------------
//with onPartialUpdate, the println()'s are useful for debugging.  
//If you exceed the budget, you can see by how much, etc.  The do1hz is used in onUpdate()
// and is key.
//-----------------------------------------------------------------------------
class WF1Delegate extends Ui.WatchFaceDelegate
{
    //-----------------------------------------------------
    function initialize() 
    {
        logMsg("WF1Delegate.init");
        WatchFaceDelegate.initialize(); 
    }

    //-----------------------------------------------------
    function onPowerBudgetExceeded(powerInfo) 
    {
        Sys.println( "Average execution time: " + powerInfo.executionTimeAverage );
        Sys.println( "Allowed execution time: " + powerInfo.executionTimeLimit );
        do1hz=false;
    }
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class WF1View extends Ui.WatchFace 
{
    var inLowPower=true;
    var g;
    var tmStart = 0;
    
    //-----------------------------------------------------
    function initialize() 
    {
        WatchFace.initialize();
        logMsg("WF1View.init");

        do1hz = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );
        canDo1hz=do1hz;  
        tmStart = Sys.getTimer();       
    }

    //-----------------------------------------------------
    function onShow() 
    {
        logMsg("WF1View.show");
    }
    //-----------------------------------------------------
    function onHide() 
    {
        logMsg("WF1View.hide");
    }

    //-----------------------------------------------------
    function onLayout(dc)
    {
        g = new Gx(); //initialize the Graphics helper component        
    
    }

    //-----------------------------------------------------
    // Update the view
    const ClrBG = Gx.ClrBlack;
    const ClrFG = Gx.ClrWhite;
    
    var steps = 0;
    var alt = null;
    function onUpdate(dc) 
    {
        ++cUpdate;
        //Sys.println(strTimeOfDay(true) + ": onUpdate");
        
        //if device can do 1hz, make sure to clear the clip in case you exceeded the 
        // power limit but there's still a clip
        if(canDo1hz) {dc.clearClip();}
    
    
        g.setDC(dc);
        //Sys.println("onUpdate: dc=" + dc); 
        g.clear(ClrBG);

        var settings = Sys.getDeviceSettings();

        //version
        var strVer = settings.firmwareVersion[0] + "." + settings.firmwareVersion[1].format("%02d");

        if (settings.phoneConnected)
        {
            //dc.setColor(Gx.ClrRed,Gx.ClrRed);
            g.fillCircle(Gx.xCenter,4,4,Gx.ClrRed);
            //dc.setColor(ClrFG, ClrBG);
            //strStatus += " P";
        }
        
        //---status line
        var lvl = Sys.getSystemStats().battery;
        var strStatus = lvl.format("%02d") + "%";
        strStatus += " " + strVer;
        g.drawTextY(120,8, Gx.F2, strStatus, Gx.JCT, ClrFG);
        
        //date
        var now = Time.now();
        var tminfo = Calendar.info(now,Time.FORMAT_SHORT);
        var tminfoL = Calendar.info(now,Time.FORMAT_LONG);
        var strDate = Lang.format("$1$ $3$",
            [tminfoL.day_of_week,tminfoL.month,tminfo.day,tminfo.year]);
        g.drawTextY(120,30, Gx.F3, strDate, Gx.JCT, ClrFG);
        
        //---diagnostics line
        g.drawTextY(120,85, Gx.F1, "testWF", Gx.JCM, ClrFG);
        g.drawTextY(120,65, Gx.F1, strDur(Sys.getTimer() - tmStart) + " - " + strDur(Sys.getTimer()), Gx.JCM, ClrFG);
        
        //---main time
        g.drawTextY(188,145, Gx.FN3, strTimeOfDay(false), Gx.JR_, ClrFG);

        //---Activity monitor stuff - HR, Steps
        if (steps != 0)
        {
            g.drawTextY(60,178, Gx.F4, steps.format("%d"), Gx.JC_, ClrFG);
        }   

        //---- weather station data
        if (wsdata != null)
        {
            //Sys.println(wsdata);
            if (wsdata != null)
            {
                var strT = wsdata[WS_TO1]+"°";
                g.drawTextY(70,204, Gx.F4, wsdata[WS_TI1]+"°", Gx.JC_, ClrFG);
                g.drawTextY(126,204, Gx.F4, wsdata[WS_TO1]+"°", Gx.JC_, ClrFG);
                g.drawTextY(180,204, Gx.F4, wsdata[WS_WS10], Gx.JR_, ClrFG);
                g.drawTextY(181,193, Gx.F1, "mph", Gx.JL_, Gx.ClrLtGray);
            }
        }
        
        //---- elevation
        //var actinfo = System.Activity.getActivityInfo();
        //Sys.println("actinfo: " + actinfo);
        //if ((actinfo != null) && (actinfo.altitude != null))
        if (alt != null)
        {
            var strAlt = (alt * FtPerMeter).format("%d");
            g.drawTextY(Gx.xCenter,Gx.cyScreen,Gx.F4,strAlt,Gx.JCB,ClrFG);
        }
        
        //---- Seconds - do this last because it sets a clip area
        onPartialUpdate(dc);
    }

    //-----------------------------------------------------
    function getHR()
    {
        var hr = null;
        if (Toybox has :ActivityMonitor)
        {
            var moninfo = Toybox.ActivityMonitor.getInfo();
//            if (Toybox.ActivityMonitor has :getHeartRateHistory)
//            {
//              var hrIterator = Toybox.ActivityMonitor.getHeartRateHistory(null, true);
//              var hrObj = hrIterator.next();
//              if (hrObj != null) {hr = hrObj.heartRate;}
//              if (hr == 255) {hr = null;}
//            }
            if (moninfo has :steps)
            {
                steps = moninfo.steps;
            }   
        }    
        
        var actinfo = System.Activity.getActivityInfo();
        //Sys.println("actinfo: " + actinfo);
        if (actinfo != null)
        {
            alt = actinfo.altitude;
            hr = actinfo.currentHeartRate;
        }
        else
        {
            alt = null;
        }
        
        return(hr);    
    }
    //-----------------------------------------------------
    function onPartialUpdate(dc)
    {
        cPartial++;
        //Sys.println(cPartial);
        //var g = gxGlobal.getGx(dc);
        g.setDC(dc);
        g.setClip(183, 112, 57, 67); //need scaling

        g.fillRect(192, 112, 100,35,ClrBG);    //seconds
        g.fillRect(183, 146, 100,34,ClrBG);    //hr

        var strSec = Sys.getClockTime().sec.format("%02d");
        g.drawTextY(192,145, Gx.FN1, strSec, Gx.JL_, ClrFG);

        var hr = getHR();
        if (hr != null)
        {
            g.drawTextY(183,178, Gx.F4, hr, Gx.JL_, ClrFG);
        }
        
        //var strSec = cPartial;
        
        //dc.setColor(ClrFG, ClrBG);
        //y = adjustY(y,iFnt,just);
        //dc.drawText(192,145,Gfx.FONT_SMALL,strSec,Gfx.TEXT_JUSTIFY_LEFT); //first pixels close to y
        
    }
    //-----------------------------------------------------
    function onExitSleep() 
    {
        inLowPower=false;
        //if you are doing 1hz, there's no reason to do the Ui.reqestUpdate()
        // (see note below too)
        //if(!do1hz) {Sys.println("exit sleep");Ui.requestUpdate();} 
    }

    //-----------------------------------------------------
    function onEnterSleep() 
    {
        // Terminate any active timers and prepare for slow updates.
        inLowPower=true;
        // and if you do it here, you may see "jittery seconds" when the watch face drops back to low power mode
        //if(!do1hz) {Sys.println("enter sleep");Ui.requestUpdate();} 
    }

}
