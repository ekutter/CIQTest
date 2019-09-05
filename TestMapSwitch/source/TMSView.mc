using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

//---------------------------------------------------------
//---------------------------------------------------------
class TestMapSwitchDelegate extends Ui.BehaviorDelegate 
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
        Ui.popView(Ui.SLIDE_IMMEDIATE); //back to the exit window
        return(true);
    }

    //---------------------------------
    function onNextPage()
    {
        Sys.println("onNextPage");
        var view = new AppMapView();
        Ui.switchToView(view, new AppMapDelegate(view), Ui.SLIDE_IMMEDIATE);
        Ui.requestUpdate();
        return(true); //prevent the swipe from happening
    }

    //---------------------------------
    function onPreviousPage()
    {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
        var view = new AppMapView();
        Ui.pushView(view, new AppMapDelegate(view), Ui.SLIDE_IMMEDIATE);
        Ui.requestUpdate();
        return(true);
    }
}

//---------------------------------------------------------
//---------------------------------------------------------
class TestMapSwitchView extends Ui.View 
{

    //---------------------------------
    function initialize() 
    {
        View.initialize();
    }

    //---------------------------------
    function onShow() {}

    //---------------------------------
    function onUpdate(dc) 
    {
        var xCenter = dc.getWidth()/2;
        var yCenter = dc.getHeight()/2;
        
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
        dc.clear();
        
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xCenter,yCenter/2,Gfx.FONT_LARGE,"Main Page",Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);

        dc.drawText(5,yCenter,Gfx.FONT_MEDIUM,"pop/push map",Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawText(25,yCenter/2*3,Gfx.FONT_MEDIUM,"switchToView",Gfx.TEXT_JUSTIFY_LEFT | Gfx.TEXT_JUSTIFY_VCENTER);



    }

    //---------------------------------
    function onHide(){}
}
