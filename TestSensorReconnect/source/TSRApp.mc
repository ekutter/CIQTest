using Toybox.Application as App;
using Toybox.WatchUi as Ui;

//---------------------------------------------------------
//---------------------------------------------------------
class TestSensorReconnectApp extends App.AppBase 
{
    var timer = new Ui.Timer.Timer();

    //-------------------------------------------
    function initialize() 
    {
        AppBase.initialize();
        timer.start(method(:onTimerTic),1000,true);
    }

    //--------------------------------------   
    function onTimerTic() 
    {
        Ui.requestUpdate();
    }

    //--------------------------------------   
    function getInitialView() 
    {
        var view = new TestSensorReconnectView();
        return [ view, new TestSensorReconnectDelegate(view) ];
    }
}
