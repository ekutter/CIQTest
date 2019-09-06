using Toybox.Application;
using Toybox.WatchUi as Ui;


    var sensor;
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class TestAntConnectFldApp extends Application.AppBase 
{

    //-------------------------------------------
    function initialize() 
    {
        AppBase.initialize();
    }

    //-------------------------------------------
    function onStart(state) 
    {
        sensor = new SensorSimple(SensorSimple.DEV_TRACKER);
    }

    //-------------------------------------------
    function onStop(state) 
    {
        sensor.closeSensor();
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new TestAntConnectFldView() ];
    }

}