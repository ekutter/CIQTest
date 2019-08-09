using Toybox.Application;

class TestWidgetApp extends Application.AppBase {

    function initialize() {
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