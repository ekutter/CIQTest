using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Activity as Act;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;

//---------------------------------------------------------
//---------------------------------------------------------
class AppExitDelegate extends Ui.BehaviorDelegate
{
    var view;
    //---------------------------------
    function initialize(view_)
    {
        view = view_;
        BehaviorDelegate.initialize();
    }

    //---------------------------------
    function onBack()
    {
        view.pushTestMapSwitchView();
        return(true);
    }
    
    //---------------------------------
    function onSelect()
    {
//        act.disableGPS();
        Sys.exit();
    }
    
    
}
//---------------------------------------------------------
//---------------------------------------------------------
class AppExitView extends Ui.View
{
    var fFirstTime = true;

    //---------------------------------
    function initialize() {View.initialize();}
    //---------------------------------
    function onShow()
    {
        if (fFirstTime)
        {
            fFirstTime = false;
            pushTestMapSwitchView();         //just go straight to the time view
        }
    }
    //---------------------------------
    function pushTestMapSwitchView() 
    {
        var view = new TestMapSwitchView();
        Ui.pushView(view, new TestMapSwitchDelegate(view), Ui.SLIDE_IMMEDIATE);
    }
    //---------------------------------
    // Update the view
    function onUpdate(dc)
    {
        var cxScreen = dc.getWidth();
        var cyScreen = dc.getHeight();
        var xCenter = dc.getWidth()/2;
        var yCenter = dc.getHeight()/2;
        
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.clear();
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
        dc.fillRectangle(cxScreen/4, cyScreen/3,cxScreen/2,cyScreen/3);
        
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);
        dc.drawRectangle(cxScreen/4, cyScreen/3,cxScreen/2,cyScreen/3);
        
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xCenter,yCenter,Gfx.FONT_LARGE,"Exit?",Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }
}
