using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
var xyTap = null;
class DevTestFldDelegate extends Ui.InputDelegate
{
    //-------------------------------------------
    function initialize()
    {
      InputDelegate.initialize();
    }
    //-------------------------------------------
    function onTap(evt)
    {
        xyTap = "tap "+evt.getCoordinates(); 
        Sys.println("onTap: type=" + evt.getType() + ", coord="  + evt.getCoordinates());
         
    }
    //-------------------------------------------
    function onHold(evt)
    {
        xyTap = "hold "+evt.getCoordinates(); 
        Sys.println("onHold: type=" + evt.getType() + ", coord="  + evt.getCoordinates()); 
    }
}
