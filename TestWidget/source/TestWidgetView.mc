using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

(:glance)
class MyGlanceView extends WatchUi.GlanceView
{
    function initialize() {
        GlanceView.initialize();
    }
    
    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);
        dc.clear();
    }
}

class MyWidgetView extends WatchUi.View
{
    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);
        dc.clear();
        
    }
}

(:background)
class MyServiceDelegate extends Sys.ServiceDelegate
{
    function initialize() {
        ServiceDelegate.initialize();
    }
}

