//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!
//! This code is a slightly modified version of the Connect IQ SDK SampleRecord
//!


using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Lang;
using Toybox.ActivityRecording;
using Toybox.Activity as Act;

var session = null;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class BaseInputDelegate extends WatchUi.InputDelegate // WatchUi.BehaviorDelegate
{
    //-------------------------------------------
    function initialize() {InputDelegate.initialize();}
    
    //-------------------------------------------
    function onKey(evt)
    {
        Sys.println("onKey: " + evt.getKey());
        switch (evt.getKey())
        {
        case WatchUi.KEY_ENTER:
            toggleStartStop();
            return(true);
        case WatchUi.KEY_ESC:
            Sys.println("KeyEsc: " + (session != null)); 
            return(session != null);
        default:
            return(false);
        }
    }

    //-------------------------------------------
    function onHold(evt) {Sys.println("onHold: "); toggleStartStop();} //S62 never gets the onKey(Enter) after the activity is starated
    
    //-------------------------------------------
    function toggleStartStop()
    {
        Sys.println("toggleStartStop()");
        
        if( ( session == null ) || ( session.isRecording() == false ) ) 
        {
            session = ActivityRecording.createSession({:name=>("TestCIQApp" +(fHR?"T":"F")), :sport=>ActivityRecording.SPORT_WALKING});
            session.start();
            WatchUi.requestUpdate();
        }
        else if( ( session != null ) && session.isRecording() ) 
        {
            session.stop();
            session.save();
            session = null;
            WatchUi.requestUpdate();
        }
        return true;
    }
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class TestRecordView extends WatchUi.View {

    //-------------------------------------------
    function initialize() {View.initialize();}

    //-------------------------------------------
    function stopRecording() 
    {
        if( session != null && session.isRecording() ) 
        {
            session.stop();
            session.save();
            session = null;
            WatchUi.requestUpdate();
        }
    }

    //-------------------------------------------
    var rgGPSQual = ["N/A","LastKnown","Poor","Usable","Good"];
    var rgclr = [Graphics.COLOR_BLACK,Graphics.COLOR_RED,Graphics.COLOR_ORANGE,Graphics.COLOR_YELLOW,Graphics.COLOR_GREEN];
    var rgcQual = [0,0,0,0,0];
    var strAccuracy = "N/A";
    
    function onUpdate(dc) 
    {
        // Set background color
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth()/2, 0, Graphics.FONT_XTINY, "M:"+Sys.getSystemStats().usedMemory, Graphics.TEXT_JUSTIFY_CENTER);

        var x = dc.getWidth() / 2;
        var y = dc.getFontHeight(Graphics.FONT_XTINY);
        var dy = dc.getFontHeight(Graphics.FONT_MEDIUM);
        var clr = Graphics.COLOR_BLACK;
        
        var info = Act.getActivityInfo();
        if (info.currentLocationAccuracy != null)
        {
            rgcQual[info.currentLocationAccuracy]++;
            strAccuracy = rgGPSQual[info.currentLocationAccuracy];
            clr = rgclr[info.currentLocationAccuracy];                           
        }
        else
        {
            strAccuracy = "null";
        }
        dc.setColor(clr, Graphics.COLOR_WHITE);
        
        dc.drawText(x, y, Graphics.FONT_MEDIUM, "GPS: " + strAccuracy, Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        
        dc.drawText(x, y, Graphics.FONT_MEDIUM, Lang.format("$1$,$2$,$3$,$4$,$5$",rgcQual), Graphics.TEXT_JUSTIFY_CENTER);
        y += dy;

        if ((session != null) && session.isRecording())
        {               
            dc.drawText(x, y, Graphics.FONT_MEDIUM, strDist(info.elapsedDistance) + "mi" , Graphics.TEXT_JUSTIFY_CENTER);
            y += dy;
            
            dc.drawText(x, y, Graphics.FONT_MEDIUM, strDur(info.timerTime) , Graphics.TEXT_JUSTIFY_CENTER);
            y += dy;

            if ((info has :altitude) && (info.altitude != null))
            {
                dc.drawText(x, y, Graphics.FONT_MEDIUM, (info.altitude*3.28084).toNumber() + "'" , Graphics.TEXT_JUSTIFY_CENTER);
                y += dy;
            }
            
            if ((info has :currentHeartRate) && (info.currentHeartRate != null))
            {
                dc.drawText(x, y, Graphics.FONT_MEDIUM, info.currentHeartRate + "bpm" , Graphics.TEXT_JUSTIFY_CENTER);
                y += dy;
            }
        }
        else
        {
            dc.drawText(x, y, Graphics.FONT_MEDIUM, "Press Start", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
    
    //-------------------------------------------
    const MetersPerMile = 1609.344;
    function strDist(mtr) {return((mtr != null) ? (mtr/MetersPerMile).format("%.2f") : "--");}
    function strDur(time)
    {
        if (time==null) {return("--");}
    
        var tm = (time / 1000).toNumber();
        var hours = (tm / (60 * 60)).toNumber();
        var minutes = ((tm % (60*60)) / 60).toNumber();
        var seconds = (tm % 60).toNumber();
        var strTime;
        if (hours > 99)
        {
            var days = (hours / 24).toNumber();
            hours = hours % 24;
            strTime = days + "d" + hours.format("%02u") + ":" + minutes.format("%02u");
        }
        else if (hours > 0)
        {
            strTime = hours +":" + minutes.format("%02u")+":"+seconds.format("%02u");
        }
        else
        {
            strTime = minutes.format("%u")+":"+seconds.format("%02u");
        }
        return(strTime);
    }
    

}
