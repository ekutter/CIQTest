using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Lang as Lang;


//---------------------------------------------------------
//---------------------------------------------------------
class State
{
    enum {PgHome, PgCount}
    var pgCur = PgHome;
    var http = new HttpData();
    //---------------------------------
    function initialize()
    {
    }
    
    //---------------------------------
    function onTimerTic()
    {
        updateSensors();
    }
    
    //---------------------------------
    function done()
    {
    }
    
    //---------------------------------
    function setPg(increment)
    {
        var pgLast = pgCur;
        do
        {
            pgCur = (pgCur + increment + PgCount) % PgCount;
        } while (!isPgVisible(pgCur));
        
        switch (pgCur)
        {
        //case PgHome: return(Ui.switchToView(new PgHomeView(), new PgHomeDelegate(), Ui.SLIDE_IMMEDIATE));
            //return;
        default:
        }
    }

    //---------------------------------
    function isPgVisible(pg)
    {
        switch (pg)
        {
        case PgHome:
            return(true); //always
        default:
            return(false);
        }
    }    
    //---------------------------------
    const r = 10;
    const incrFrict = 15;
    const pcntFrict = 99;
    const wallLoss = 80;
    const arrowLen = 25.0;
    const hitForce = 50.0;
    const velocityToPix = 0.004; // 1/250

    var dataTimer;

    var accel;
    var mag;
    
    function updateSensors()
    {
        var info = Sensor.getInfo();

        if (info has :accel && info.accel != null) {
            accel = info.accel;
        }

        if (info has :mag && info.mag != null) {
            mag = info.mag;
        }

        WatchUi.requestUpdate();
    }
    
}