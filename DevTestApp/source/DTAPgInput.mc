using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;

//---------------------------------------------------------
//---------------------------------------------------------
class PgInputDelegate extends Ui.InputDelegate
{
    var view;
    var tmKeyPressed;
    function initialize(view_) 
    {
        view = view_; 
        tmKeyPressed = Sys.getTimer()-2000;
    }

    //---------------------------------
    // InputDelegate
    
    //Ui.ClickEvent - touch screen
    //  getCoordinates() -> [x,y]
    //  getType() CLICK_TYPE_ {TAP=0, HOLD=1, RELEASE=2}
    static const rgstrClick = ["Tap", "Hold", "Release"];
    static function strClick(click) {return(click + " " + (click < rgstrClick.size()) ? rgstrClick[click] : "inv click");}
    
    function onHold(clickevt) {view.addEvent(["onHold", strClick(clickevt.getType()) + ", " + clickevt.getCoordinates()]);}            
    function onRelease(clickevt) {view.addEvent(["onRelease", strClick(clickevt.getType()) + ", " + clickevt.getCoordinates()]);}
    function onTap(clickevt) {view.addEvent(["onTap", strClick(clickevt.getType()) + ", " + clickevt.getCoordinates()]);}
    
    //---------------------------------
    //Ui.KeyEvent: 
    //  getKey() Ui.KEY_
    //  getType() Ui.KEY_
    //  Key_ {POWER=0, LIGHT=1, ZIN=2, ZOUT=3, ENTER=4, ESC=5, FIND=6, MENU=7, 
    //        DOWN=8, DOWN_LEFT=9, DOWN_RIGHT=10, LEFT=11, RIGHT=12, UP=13, UP_LEFT=14, UP_RIGHT=15,
    //        EXTENDED_KEYS=16, - indicates extended key support
    //        PAGE=17, START=18, LAP=19, RESET=20, SPORT=21, CLOCK=22, MODE=23
    static const rgstrKey = [
        "Power", "Light", "ZIn", "ZOut", "Enter", "Esc", "Find", "Menu",
        "Down", "DnLeft", "DnRight", "Left", "Right", "Up", "UpLeft", "UpRight",
        "ExtKeys", "Page", "Start", "Lap", "Reset", "Sport", "Clock", "Mode"];
    static function strKey(key) {return(key + " " + (key < rgstrKey.size()) ? rgstrKey[key] : "inv key");}
         
    function onKey(keyevt) 
    {
        var key = keyevt.getKey();
        switch (key)
        {
        case Ui.KEY_DOWN:
            //return(state.setPg(1));
        case Ui.KEY_UP:
            //return(state.setPg(-1));
        default:
            view.addEvent(["onKey", strKey(keyevt.getKey())+" "+Sys.getTimer().toString()]);
            break;            
        }
        return(true);
    }
    function onKeyPressed(keyevt)
    {
        tmKeyPressed = Sys.getTimer();
        view.clearEvent();view.addEvent(["onKeyPressed", strKey(keyevt.getKey())+" "+Sys.getTimer()]);
    }
    function onKeyReleased(keyevt) 
    {
        //go to the next page if the button was just pressed and not held
        if ((Sys.getTimer() - tmKeyPressed) < 500)
        {
	        var key = keyevt.getKey();
	        switch (key)
	        {
	        case Ui.KEY_DOWN:
	            return(state.setPg(1));
	        case Ui.KEY_UP:
	            return(state.setPg(-1));
	        }
        }
        view.addEvent(["onKeyReleased", strKey(keyevt.getKey())+" "+Sys.getTimer().toString()]);
        return(true);
    }
    
    //---------------------------------
    function onSelectable(selevt) {view.addEvent(["onSelectable", "What is this used for"]);}        //Ui.SelectableEvent - not sure when this is ever used

    //---------------------------------
    const rgstrSwipe = ["UP", "RIGHT", "DOWN", "LEFT"];    
    function strSwipe(swipe) {return(swipe + " " + (swipe < rgstrSwipe.size()) ? rgstrSwipe[swipe] : "inv swipe");}
    function onSwipe(swipeevt) 
    {
        var swipe  = swipeevt.getDirection();
        switch (swipe)
        {
        case Ui.SWIPE_LEFT:
            state.setPg(1);
            break;
        case Ui.SWIPE_RIGHT:
            state.setPg(-1);
            return(true);
        default:
            view.addEvent(["onSwipe", strSwipe(swipeevt.getDirection())]);
        }
        return(false);
    }   
}
//---------------------------------------------------------
//---------------------------------------------------------
class PgInputBehaviorDelegate extends Ui.BehaviorDelegate
{
    var view;
    var tmKeyPressed;

    function initialize(view_) 
    {
        view = view_;
        view.strTitle="Behavior";
        tmKeyPressed = Sys.getTimer()-2000;
    }

    //---------------------------------
    // InputDelegate
    
    //Ui.ClickEvent - touch screen
    //  getCoordinates() -> [x,y]
    //  getType() CLICK_TYPE_ {TAP=0, HOLD=1, RELEASE=2}
    const rgstrClick = ["Tap", "Hold", "Release"];
    function strClick(click) {return(click + " " + (click < rgstrClick.size()) ? rgstrClick[click] : "inv click");}
    
    function onHold(clickevt) {view.addEvent(["onHold", strClick(clickevt.getType()) + ", " + clickevt.getCoordinates()]);}            
    function onRelease(clickevt) {view.addEvent(["onRelease", strClick(clickevt.getType()) + ", " + clickevt.getCoordinates()]);}
    function onTap(clickevt) {view.addEvent(["onTap", strClick(clickevt.getType()) + ", " + clickevt.getCoordinates()]);}
    
    //---------------------------------
    //Ui.KeyEvent: 
    //  getKey() Ui.KEY_
    //  getType() Ui.KEY_
    //  Key_ {POWER=0, LIGHT=1, ZIN=2, ZOUT=3, ENTER=4, ESC=5, FIND=6, MENU=7, 
    //        DOWN=8, DOWN_LEFT=9, DOWN_RIGHT=10, LEFT=11, RIGHT=12, UP=13, UP_LEFT=14, UP_RIGHT=15,
    //        EXTENDED_KEYS=16, - indicates extended key support
    //        PAGE=17, START=18, LAP=19, RESET=20, SPORT=21, CLOCK=22, MODE=23
    const rgstrKey = [
        "Power", "Light", "ZIn", "ZOut", "Enter", "Esc", "Find", "Menu",
        "Down", "DnLeft", "DnRight", "Left", "Right", "Up", "UpLeft", "UpRight",
        "ExtKeys", "Page", "Start", "Lap", "Reset", "Sport", "Clock", "Mode"];
    function strKey(key) {return(key + " " + (key < rgstrKey.size()) ? rgstrKey[key] : "inv key");}
         
    function onKey(keyevt) {view.addEvent(["onKey", strKey(keyevt.getKey())+" "+Sys.getTimer().toString()]);}             
    function onKeyPressed(keyevt)
    {
        tmKeyPressed = Sys.getTimer();
        view.clearEvent();view.addEvent(["onKeyPressed", strKey(keyevt.getKey())+" "+Sys.getTimer()]);
    }
    function onKeyReleased(keyevt) 
    {
        //go to the next page if the button was just pressed and not held
        if ((Sys.getTimer() - tmKeyPressed) < 500)
        {
            var key = keyevt.getKey();
            switch (key)
            {
            case Ui.KEY_DOWN:
                return(state.setPg(1));
            case Ui.KEY_UP:
                return(state.setPg(-1));
            }
        }
        view.addEvent(["onKeyReleased", strKey(keyevt.getKey())+" "+Sys.getTimer().toString()]);
        return(true);
    }
    
    //---------------------------------
    function onSelectable(selevt) {view.addEvent(["onSelectable", "What is this used for"]);}        //Ui.SelectableEvent - not sure when this is ever used

    //---------------------------------
    const rgstrSwipe = ["UP", "RIGHT", "DOWN", "LEFT"];    
    function strSwipe(swipe) {return(swipe + " " + (swipe < rgstrSwipe.size()) ? rgstrSwipe[swipe] : "inv swipe");}
    function onSwipe(swipeevt) 
    {
        var d = swipeevt.getDirection();
        if (d == Ui.SWIPE_LEFT) {state.setPg(1);}
        else if (d == Ui.SWIPE_RIGHT) {state.setPg(-1);}
        else
        {
	        view.clearEvent();
	        view.addEvent(["onSwipe", strSwipe(d)]);
        }
        return(false);
    }     
    
    //---------------------------------
    // Behavior Delegate
    function onMenu() {view.addEvent(["onMenu"]);}            //KEY_MENU
    function onBack() {view.addEvent(["onBack"]);return(true);}            //KEY_ESC
    function onNextMode() {view.addEvent(["onNextMode"]);}        //??
    //function onNextPage() {}        //KEY_UP, SWIPE_UP
    function onPreviousMode() {view.addEvent(["onPreviousMode"]);}    //??
    //function onPreviousPage() {}    //KEY_UPDOWN
    function onSelect() {view.addEvent(["onSelect"]);return(false);}          //KEY_ENTER, CLICK_TYPE_TAP

    function onNextPage() {view.addEvent(["onNextPage"]);return(false);}     
    function onPreviousPage() {view.addEvent(["onPreviousPage"]);return(false);} 
}

//---------------------------------------------------------
class PgInputView extends Ui.View
{
    var rgEvt = [];
    var strTitle = "Input";
    var cEvt = 0;
    
    function initialize()
    {
        Ui.View.initialize();
    }
    //---------------------------------
    function onUpdate(dc)
    {
	    dc.setColor(ClrBG,ClrBG);
	    dc.clear();
	
	    var y = 4;
	    fillRect(dc,0,0,cxScreen,FntAscent[F4],ClrYellow);
	    y += drawTextY(dc,xCenter,y,F4,strTitle + " " + cEvt,JC,ClrBlack);
	    
	    
	    for (var i = rgEvt.size()-1; i > -1; i -= 1 )
	    //for (var i = 0; i < rgEvt.size(); i += 1 )
	    {  
	        var rgstr = rgEvt[i];
	        var fnt = F4;
	        for (var j = 0; j < rgstr.size(); ++j)
	        { 
                y += drawTextY(dc,xCenter,y,fnt,rgstr[j],JC,ClrFG);
                fnt = F3;
            }
            drawRect(dc,0,y-2,cxScreen,2,ClrRed);
            y += 2;
	    }
	}
    //---------------------------------
    function clearEvent() {rgEvt=[];}
    //---------------------------------
    function addEvent(rgstr)
    {
        Sys.println("addEvent" + rgstr);
        ++cEvt;
        rgEvt.add(rgstr);
        if (rgEvt.size() > 5)
        {
            rgEvt = rgEvt.slice(rgEvt.size()-5,rgEvt.size());
        }
        Ui.requestUpdate();
    }
}