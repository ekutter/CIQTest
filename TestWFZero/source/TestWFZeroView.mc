using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class TestWFZeroView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get and show the current time
        var view = View.findDrawableById("TimeLabel");
        view.setText(strTime(false));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }
    function strTime(fLong)
    {    
        var hour, min, result;
        var clockTime = System.getClockTime();
        
        hour = clockTime.hour % 12;
        hour = (hour == 0) ? 12 : hour;
        min = clockTime.min;
    
        var str = Lang.format("$1$:$2$",[hour, min.format("%02d")]);
    
        if (fLong)
        {
            var ampm = (clockTime.hour < 12) ? "a" : "p";
            str = str + Lang.format(":$1$",[clockTime.sec.format("%02d")]);
        }
        return (str);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
