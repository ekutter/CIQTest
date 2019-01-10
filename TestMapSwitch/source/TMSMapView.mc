using Toybox.WatchUi as Ui;
using Toybox.Activity as Act;
using Toybox.System as Sys;
using Toybox.Position as Position;
using Toybox.Lang as Lang;
using Toybox.Math as Math;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class AppMapDelegate extends Ui.BehaviorDelegate
{
    var view;
    function initialize(view_)
    {
        view = view_;
        BehaviorDelegate.initialize();
    }

    //---------------------------------
    function onNextPage()
    {
	    var view = new TestMapSwitchView();
	    Ui.switchToView(view, new TestMapSwitchDelegate(view), Ui.SLIDE_IMMEDIATE);
	    Ui.requestUpdate();
        return(true); //prevent the swipe from happening
    }

    //---------------------------------
    function onPreviousPage()
    {
        return(onNextPage());  //both go back
    }
}
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class AppMapView extends Ui.MapTrackView
{
    //---------------------------------
    function initialize()
    {
        MapTrackView.initialize();

        // set the current mode for the Map to be preview
        setMapMode(Ui.MAP_MODE_PREVIEW);

        // create the bounding box for the map area
        var top_left = new Position.Location({:latitude => 38.85695, :longitude =>-94.80051, :format => :degrees});
        var bottom_right = new Position.Location({:latitude => 38.85391, :longitude =>-94.7963, :format => :degrees});
        MapView.setMapVisibleArea(top_left, bottom_right);

		var cxScreen = Sys.getDeviceSettings().screenWidth;
		var cyScreen = Sys.getDeviceSettings().screenHeight;

//        MapView.setScreenVisibleArea(0, 0,cxScreen, cyScreen);
        MapView.setScreenVisibleArea(0, System.getDeviceSettings().screenHeight / 2, System.getDeviceSettings().screenWidth, System.getDeviceSettings().screenHeight);
    }

    //---------------------------------
    function onUpdate(dc)
    {
        MapView.onUpdate(dc);
    }
}

