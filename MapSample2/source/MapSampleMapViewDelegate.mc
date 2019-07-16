using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class MapSampleMapDelegate extends Ui.BehaviorDelegate {

    var mView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mView = view;
    }

    function onBack() {
        // if current mode is preview mode them pop the view
        if(mView.getMapMode() == Ui.MAP_MODE_PREVIEW) {
            Ui.popView(Ui.SLIDE_UP);
        } else {
            // if browse mode change the mode to preview
            mView.setMapMode(Ui.MAP_MODE_PREVIEW);
        }
        return true;
    }

    function onSelect() {
        // on enter button press chenage the map view to browse mode
        mView.setMapMode(Ui.MAP_MODE_BROWSE);
        return true;
    }
    
    function onMenu() {
        Sys.println("onMenu");
        Ui.pushView(new Rez.Menus.MapMenu(), new MapSampleMapMenuDelegate(), Ui.SLIDE_UP);
    }
        
    function onNextPage()
    {
        if (mView has :zoomOut)
        {
            mView.zoomOut();
        }
    }

    function onPreviousPage()
    {
        if (mView has :zoomIn)
        {
            mView.zoomIn();
        }
    }
}