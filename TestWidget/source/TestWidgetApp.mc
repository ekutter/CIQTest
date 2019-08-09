using Toybox.Application;
using Toybox.System as Sys;

class TestWidgetApp extends Application.AppBase {

    function initialize() {
        Sys.println("TestWidgetApp");
        Sys.println(strTimeOfDay(true));
        AppBase.initialize();
    }
    
    (:background) function getServiceDelegate() {
        return [ new MyServiceDelegate() ];
    }
    
    (:glance) function getGlanceView() {
        return [ new MyGlanceView() ];
    }
    
    function getInitialView() {
        return [ new MyWidgetView() ];
    }

}