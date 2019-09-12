//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!
//! This code is a slightly modified version of the Connect IQ SDK SampleRecord
//!

using Toybox.Application;
using Toybox.Position;
using Toybox.WatchUi;

var fHR = true;
class TestRecordApp extends Application.AppBase {

    var timer;
    var view;

    function initialize() {
        AppBase.initialize();
    }

    //! onStart() is called on application start up
    //! We need to enable the location events for now so that we make sure GPS
    //! is on.
    function onStart(state) {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        
        if (fHR) {Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);}

        timer = new Timer.Timer(); //on timer needs to be here for the epix
        timer.start(method(:onTimer),1000,true);
    }

    //---------------------------------
    function onTimer()
    {
        WatchUi.requestUpdate();
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
        view.stopRecording();
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    function onPosition(info) {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        view = new TestRecordView();
        return [ view, new BaseInputDelegate() ];
    }

}