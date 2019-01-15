using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

//---------------------------------------------------------
var logMsg;
var state;
class GolfSwingApp extends App.AppBase 
{
    const DurUpdScreen = 1 * 1000;       //how often to redraw the screen
    var timer = new Ui.Timer.Timer();

    //---------------------------------
    function initialize() 
    {
        AppBase.initialize();

        Sys.println(Lang.format("$1$ starting $2$ $3$",
            [strTimeOfDay(true), 
             Ui.loadResource(Rez.Strings.AppName), 
             Sys.getDeviceSettings().uniqueIdentifier.substring(0,4)]));
        Sys.println("Sys.getTimer(): " + Sys.getTimer());
        
        initDrawingHelper();
        state = new State();
        timer.start(method(:onTimerTic),DurUpdScreen,true);
    }
    //---------------------------------
    function onTimerTic() //every second
    {
        state.onTimerTic();
        Ui.requestUpdate();
    }

    function onStart(state) {}
    function onStop(state) {}

    function getInitialView() 
    {
        var view = new GolfSwingView();
        return [ view, new GolfSwingDelegate(view) ];
    }

}
