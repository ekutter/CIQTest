using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
var xyTap = null;

class DevTestFldApp extends App.AppBase {

    //-------------------------------------------
    function initialize() {
        AppBase.initialize();

        var set = Sys.getDeviceSettings();
        var stats = Sys.getSystemStats();
        
        Sys.println("\n-----------\n"+strTimeOfDay() + ": DevTestFld initialize");
        Sys.println("dist units=" + set.distanceUnits);
        Sys.println("FW Version="+set.firmwareVersion);
        Sys.println("24hr="+set.is24Hour);
        Sys.println("monkey ver="+set.monkeyVersion);
        Sys.println("part #="+set.partNumber);
        Sys.println(Lang.format("mem used=$1$k, df max mem=$2$k",
            [stats.usedMemory/1024, 
             stats.totalMemory/1024]));
        Sys.println("--------");
             
    }

    //-------------------------------------------
    function onStart(state) {
    }

    //-------------------------------------------
    function onStop(state) {
    }

    //-------------------------------------------
    function getInitialView() {
        return [ new DevTestFldView(), new DevTestFldDelegate() ];
    }

}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class DevTestFldDelegate extends Ui.InputDelegate
{
    //-------------------------------------------
    function onTap(evt)
    {
        xyTap = "tap "+evt.getCoordinates(); 
        Sys.println("onTap: type=" + evt.getType() + ", coord="  + evt.getCoordinates());
         
    }
    function onHold(evt)
    {
        xyTap = "hold "+evt.getCoordinates(); 
        Sys.println("onHold: type=" + evt.getType() + ", coord="  + evt.getCoordinates()); 
    }
}
