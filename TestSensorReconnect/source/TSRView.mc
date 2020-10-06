using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

//---------------------------------------------------------
//---------------------------------------------------------
class TestSensorReconnectDelegate extends Ui.BehaviorDelegate 
{
    var view;
    
    //-------------------------------------------
    function initialize(view_) 
    {
        BehaviorDelegate.initialize();
        view = view_;
    }

    //-------------------------------------------
    function onSelect()
    {
        view.toggleSensor();  //switch between the two sensor ID's
    }
    
    //-------------------------------------------
    function onNextPage()
    {
        view.nextSNSType(1);
    }
    
    //-------------------------------------------
    function onPreviousPage()
    {
        view.nextSNSType(-1);
    }
}
//---------------------------------------------------------
//---------------------------------------------------------
class TestSensorReconnectView extends Ui.View 
{
    var s1;     //sensor 1 - during search, and the sensor that gets toggled
    var s2;     //sensor 2 - only used during setup, then will be null
    
    var id1 = 0;
    var id2 = 0;
    var idCur;  //current ID during toggling - should equal s1.idSensor
   
    var fSensorsFound = false;  //have we found 2 sensors yet?
    
    var snsType=SNS_HR; //sensor type - this gets incremented in nextSNS so will be 0=HR

    //-------------------------------------------
    function initialize() 
    {
        View.initialize();
        nextSNSType(0); //start off with two HR sensors
    }

    //-------------------------------------------
    function toggleSensor()
    {
        if (fSensorsFound)
        {
            idCur = (idCur == id1) ? id2 : id1;
            s1.resetSensor(idCur);
            Ui.requestUpdate();
        }
    }
    //-------------------------------------------
    // new sensor type, so reset everything.
    // re-search for 2 sensors of this type
    function nextSNSType(inc)
    {
        fSensorsFound = false;
        id1=0;
        id2=0;
        snsType = (snsType+inc+SNS_COUNT) % SNS_COUNT;
        if (s1 != null) {s1.closeSensor();}
        if (s2 != null) {s2.closeSensor();}      
        s1 = new TestSensor(0,snsType);
        s2 = new TestSensor(0,snsType);
        Ui.requestUpdate();
    }       
    //-------------------------------------------
    function onUpdate(dc) 
    {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.clear();
       
        // if we haven't found two sensors yet, see if we have found them now
        if (!fSensorsFound)
        {
            if (s1.idSensorCur != null) {id1 = s1.idSensorCur;}
            if (s2.idSensorCur != null) {id2 = s2.idSensorCur;}
            fSensorsFound = (id1 != 0) && (id2 != 0);
            
            if (fSensorsFound)
            {
                //we found the two sensor ID's, so close s2, and now just use s1 to toggle
                s2.closeSensor();
                s2 = null;
                idCur = id1;
                
                s1.resetSensor(idCur);
            }
        }

        var fnt = Gfx.FONT_SMALL;
        var xMid = dc.getWidth()/2;
        var x = dc.getWidth() * 0.6;
        
        var str1 = fSensorsFound ? "Press Start to" : "finding sensors";
        var str2 = fSensorsFound ? "switch sensors" : "";
        dc.drawText(xMid,30,fnt, str1, Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(xMid,55,fnt, str2, Gfx.TEXT_JUSTIFY_CENTER);

        dc.drawText(x-4,95,fnt, "Sensor 1:", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(x+4,95,fnt, id1, Gfx.TEXT_JUSTIFY_LEFT);

        dc.drawText(x-4,120,fnt, "Sensor 2:", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(x+4,120,fnt, id2, Gfx.TEXT_JUSTIFY_LEFT);

        dc.drawText(xMid,215,fnt, TestSensor.rgName[snsType], Gfx.TEXT_JUSTIFY_CENTER);

        if (fSensorsFound)
        {
            if ((s1.idSensorCur != null) && (s1.idSensorRequested != s1.idSensorCur))
            {
                dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
            } 
            //only display the current status once we've found the two sensor id's
            dc.drawText(x-4,155,fnt, "requested:", Gfx.TEXT_JUSTIFY_RIGHT);
            dc.drawText(x+4,155,fnt, s1.idSensorRequested, Gfx.TEXT_JUSTIFY_LEFT);

            dc.drawText(x-4,180,fnt, "connected:", Gfx.TEXT_JUSTIFY_RIGHT);
            dc.drawText(x+4,180,fnt, s1.idSensorCur, Gfx.TEXT_JUSTIFY_LEFT);
        }
    }
}
