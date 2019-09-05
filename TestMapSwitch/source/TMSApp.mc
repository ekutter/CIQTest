using Toybox.Application;
using Toybox.WatchUi;

//---------------------------------------------------------
//---------------------------------------------------------
class TestMapSwitchApp extends Application.AppBase {

    //---------------------------------
    function initialize() {
        AppBase.initialize();
    }

    //---------------------------------
    function onStart(state) {}
    function onStop(state) {}

    //---------------------------------
    function getInitialView() 
    {
        var view=new AppExitView();
        return [ view, new AppExitDelegate(view) ];
    }

}
