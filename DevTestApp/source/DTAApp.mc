using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.ActivityRecording as Record;


//---------------------------------------------------------
//---------------------------------------------------------
var logMsg;
var state;
class DevTestAppApp extends App.AppBase
{
    const DurUpdScreen = 1 * 1000;       //how often to redraw the screen
    var timer = new Ui.Timer.Timer();

    //---------------------------------
    function initialize()
    {
        AppBase.initialize();
        logMsg = new LogMsg(false);
        initDrawingHelper();
        state = new State();
        timer.start(method(:onTimerTic),DurUpdScreen,true);
    }

    //---------------------------------
    function onTimerTic() //every second
    {
        //logMsg.logMsg("onTimerTic()");
        state.onTimerTic();
        Ui.requestUpdate();
    }

    //---------------------------------
    function onStart(x){}

    //---------------------------------
    function onStop(x)
    {
        state.done();
    }

    //---------------------------------
    function getInitialView()
    {
        var view=new DevTestAppView();
        return [ view, new DevTestAppDelegate() ];
    }

}
