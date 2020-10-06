using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.AntPlus as AntP;
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
        view.toggleSensor();
    }
}
//---------------------------------------------------------
//---------------------------------------------------------
class TestSensorReconnectView extends Ui.View 
{
    var s1;
    var s2;
    
    var id1 = 0;
    var id2 = 0;
    
    var idCur;
   
    var fSensorsFound = false;

    //-------------------------------------------
    function initialize() 
    {
        View.initialize();
        s1 = new TestSensor(0);
        s2 = new TestSensor(0);
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
    function onUpdate(dc) 
    {
        dc.setColor(ClrBlack,ClrWhite);
        dc.clear();
       
        dc.setColor(ClrBlack,ClrTrans);

        if (!fSensorsFound)
        {
            if (s1.idSensorCur != null) {id1 = s1.idSensorCur;}
            if (s2.idSensorCur != null) {id2 = s2.idSensorCur;}
            fSensorsFound = (id1 != 0) && (id2 != 0);
            
            if (fSensorsFound)
            {
                s2.closeSensor();
                s2 = null;
                s1.resetSensor(id1);
                idCur = id1;
            }
        }

        var fnt = F2;
        var x = 150;
        
        var str1 = fSensorsFound ? "Press Start to" : "finding sensors";
        var str2 = fSensorsFound ? "toggle sensors" : "";
        dc.drawText(130,30,F2, str1, Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(130,55,F2, str2, Gfx.TEXT_JUSTIFY_CENTER);

        dc.drawText(x-4,95,F2, "Sensor 1:", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(x+4,95,F2, id1, Gfx.TEXT_JUSTIFY_LEFT);

        dc.drawText(x-4,120,F2, "Sensor 2:", Gfx.TEXT_JUSTIFY_RIGHT);
        dc.drawText(x+4,120,F2, id2, Gfx.TEXT_JUSTIFY_LEFT);

        if (fSensorsFound)
        {
            dc.drawText(x-4,155,F2, "requested:", Gfx.TEXT_JUSTIFY_RIGHT);
            dc.drawText(x+4,155,F2, s1.idSensorRequested, Gfx.TEXT_JUSTIFY_LEFT);

            dc.drawText(x-4,180,F2, "connected:", Gfx.TEXT_JUSTIFY_RIGHT);
            dc.drawText(x+4,180,F2, s1.idSensorCur, Gfx.TEXT_JUSTIFY_LEFT);
        }
    }

}
