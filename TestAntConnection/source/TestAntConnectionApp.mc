using Toybox.Application;
using Toybox.WatchUi as Ui;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class TestAntConnectionApp extends Application.AppBase 
{
    var timer = new Ui.Timer.Timer();
    var sensor;

    //-------------------------------------------
    function initialize() 
    {
        AppBase.initialize();
        timer.start( method(:onTimerTic),3000,true);
    }

    //---------------------------------
    function onTimerTic() //every second
    {
        if (sensor.searching)
        {
            addMsg("searching...");
        }
        else
        {
            addMsg("tic cMsg=" + sensor.cMsg);
        }
        Ui.requestUpdate();
    }

    //-------------------------------------------
    function onStart(state) 
    {
        //sensor = new SensorSimple(SensorSimple.DEV_TRACKER);
        sensor = new SensorSimple(SensorSimple.DEV_FOOTPOD);
    }

    //-------------------------------------------
    function onStop(state) 
    {
        //sensor.closeSensor();
        sensor.release();
    }

    //-------------------------------------------
    function getInitialView() 
    {
        return [ new TestAntConnectionView(), new TestAntConnectionDelegate() ];
    }

}
