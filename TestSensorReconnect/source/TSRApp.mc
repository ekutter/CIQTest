using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Lang as Lang;
using Toybox.System as Sys;

//---------------------------------------------------------
//---------------------------------------------------------
class TestSensorReconnectApp extends App.AppBase {

    var view;
    var timer = new Ui.Timer.Timer();

    //-------------------------------------------
    function initialize() 
    {
        AppBase.initialize();
        
        Sys.println(Lang.format("$1$ starting $2$ id=$3$ pn=$4$, maxMem=$5$k",
            [strTimeOfDay(true), 
             "TestSensorsReconnect", //Ui.loadResource(Rez.Strings.AppName), 
             Sys.getDeviceSettings().uniqueIdentifier.substring(0,8),
             Sys.getDeviceSettings().partNumber,
             Sys.getSystemStats().totalMemory/1024
             ]));
             
        timer.start(method(:onTimerTic),1000,true);
             
    }

    //--------------------------------------   
    function onTimerTic() //every second
    {
        //logMsg.logMsg("onTimerTic()");
        //state.onTimerTic();
        Ui.requestUpdate();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() 
    {
        view = new TestSensorReconnectView();
        return [ view, new TestSensorReconnectDelegate(view) ];
    }

}
