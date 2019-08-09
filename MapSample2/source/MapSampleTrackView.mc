using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Position as Position;
using Toybox.Graphics as Gfx;
using Toybox.Activity as Act;
using Toybox.Lang as Lang;



class MapSampleTrackView extends Ui.MapTrackView {

    var zoomFactor = 8;
    var zoomX = 0.000014;
    var zoomY = 0.000019;
    var pos = [0.678863,-1.653901]; //[lat,lon]
    var posLast =[0,0];
    var zoomFactorLast = 0; 
    
    function initialize() {
        MapView.initialize();

        // set the current mode for the Map to be preview
        setMapMode(Ui.MAP_MODE_PREVIEW);
        

        updateView();

        // set the bound box for the screen area to focus the map on
        MapTrackView.setScreenVisibleArea(0, System.getDeviceSettings().screenHeight / 2, System.getDeviceSettings().screenWidth, System.getDeviceSettings().screenHeight);
    }
    
    function zoomOut(){
        Sys.println("zoomout");
        if (zoomFactor < 256)
        {
            zoomFactor *= 2;
            updateView();
        }
    }
    
    function zoomIn(){
        Sys.println("zoomIn");
        if (zoomFactor > 1)
        {
            zoomFactor /= 2;
            updateView();
        }
    }
    
    function updateView()
    {
        var info = Act.getActivityInfo();
        if ((info != null) && (info.currentLocation != null))
        {
            pos = info.currentLocation.toRadians();
        }

        if ((posLast[0] != pos[0]) || (posLast[1] != pos[1]) || (zoomFactorLast == zoomFactor))
        {
            var latD = zoomY * zoomFactor;
            var lonD = zoomX * zoomFactor;
            
            var top_left = new Position.Location({:latitude => pos[0]+latD, :longitude =>pos[1]-lonD, :format => :radians});
            var bottom_right = new Position.Location({:latitude => pos[0]-latD, :longitude =>pos[1]+lonD, :format => :radians});
            Sys.println(Lang.format("fact=$1$, TL=$2$, BR=$3$",
               [zoomFactor, top_left.toDegrees(),bottom_right.toDegrees()]));
            MapTrackView.setMapVisibleArea(top_left, bottom_right);
        }
    }

    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        MapView.onUpdate(dc);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        /*dc.drawText(
                    dc.getWidth() / 2,                      // gets the width of the device and divides by 2
                    dc.getHeight() * 3 / 4,                     // gets the height of the device and divides by 2
                    Gfx.FONT_LARGE,                    // sets the font size
                    "Hello World",                          // the String to display
                    Gfx.TEXT_JUSTIFY_CENTER            // sets the justification for the text
                  );*/
    }
}
