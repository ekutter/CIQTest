using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;

(:glance)
class MyGlanceView extends WatchUi.GlanceView
{
    function initialize() {
        Sys.println("GlanceViewInit");
        //Sys.println(strTimeOfDay(true));
        GlanceView.initialize();
    }
    
    function onUpdate(dc) {
        var xCenter = dc.getWidth() / 2;
        var yCenter = dc.getHeight() / 2;

        Sys.println("glance view: onUpdate");
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        dc.drawText(xCenter,yCenter,Gfx.FONT_LARGE, strTimeOfDay(true), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }
}

class MyWidgetView extends WatchUi.View
{
    function initialize() {
        Sys.println("ViewInit");
        Sys.println(strTimeOfDay(true));
        View.initialize();
    }

    function onUpdate(dc) {
        var xCenter = dc.getWidth() / 2;
        var yCenter = dc.getHeight() / 2;
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);
        dc.clear();

        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xCenter,yCenter,Gfx.FONT_LARGE, strTimeOfDay(true), Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        
    }
}

(:background)
class MyServiceDelegate extends Sys.ServiceDelegate
{
    function initialize() {
        ServiceDelegate.initialize();
    }
}

(:glance)
function strTimeOfDay(fLong){return(strTime(Sys.getClockTime(),fLong));}
(:glance)
function strTime(clockTime,fLong)
{    
    var hour, min, result;

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
