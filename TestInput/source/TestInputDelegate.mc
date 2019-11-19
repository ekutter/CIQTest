using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
var rgmsg = ["Press a button","or tap the screen","to see button","and touch events","","", ""];
var cMsg = 0;

class TestInputDelegate extends Ui.BehaviorDelegate 
{
    //-----------------------------------------------------
    function initialize() 
    {
        BehaviorDelegate.initialize();
    }

    //-----------------------------------------------------
    function onHold(evt){AddMsg("Hold(" + strClick(evt) + ")");}
    function onKey(evt){AddMsg("Key(" + strKey(evt) + ")");}
    function onKeyPressed(evt){AddMsg("KeyPresd(" + strKey(evt) + ")");}
    function onKeyReleased(evt){AddMsg("KeyRlsd(" + strKey(evt) + ")");}
    function onRelease(evt){AddMsg("Release(" + strClick(evt) + ")");}
    function onSwipe(evt){AddMsg("Swipe(" + strSwipe(evt) + ")");}
    function onTap(evt){AddMsg("Tap(" + strClick(evt) + ")");}

    function onBack() {AddMsg("onBack()"); return(false);}
    function onMenu() {AddMsg("onMenu()"); return(false);}
    function onNextMode() {AddMsg("onNextMode()"); return(false);}
    function onNextPage() {AddMsg("onNextPg()"); return(false);}
    function onPreviousMode() {AddMsg("onPrevMode()"); return(false);}
    function onPreviousPage() {AddMsg("onPevPg()"); return(false);}
    function onSelect() {AddMsg("onSelect()"); return(false);}
    

    //-----------------------------------------------------
    function AddMsg(str)
    {
        cMsg = (cMsg + 1) % 100;
        str = cMsg + ": " + str;
        Sys.println(str);
        rgmsg.add(str);
        if (rgmsg.size() > 10)
        {
            rgmsg.remove(rgmsg[0]);
        }
        Ui.requestUpdate();
    }
    
    //-----------------------------------------------------
    var rgstrclick = ["tap","hold","release"]; //CLICK_TYPE_
    var rgstrkey = [ //KEY_
        "power","light","zin","zout","enter","esc","find","menu","down","down_left", //0-9
        "down_right","left","right","up","up_left","up_right","extended","page","start","lap",//10-19
        "reset","sport","clock","mode"]; //20-23
    var rgstrswipe = ["up","right","down","left"];
    
    //-----------------------------------------------------
    function strClick(evt)
    {
        return(rgstrclick[evt.getType()]);  
    }
    
    //-----------------------------------------------------
    function strSwipe(evt)
    {
        return(rgstrswipe[evt.getDirection()]);
    }
    
    //-----------------------------------------------------
    function strKey(evt)
    {
        return(rgstrkey[evt.getKey()]);
    }
}
