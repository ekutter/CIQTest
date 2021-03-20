using Toybox.WatchUi as Ui;
using Toybox.Position as Position;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class MapSampleMapView extends Ui.MapView {

    function initialize() {
        MapView.initialize();
        Sys.println("a");
        // set the current mode for the Map to be preview
        setMapMode(Ui.MAP_MODE_PREVIEW);

        //updateMarkers();

        // set the bound box for the screen area to focus the map on
        // create the bounding box for the map area
        Sys.println("b");
        var top_left = new Position.Location({:latitude => 38.85695, :longitude =>-94.80051, :format => :degrees});
        var bottom_right = new Position.Location({:latitude => 38.85391, :longitude =>-94.7963, :format => :degrees});
        MapView.setMapVisibleArea(top_left, bottom_right);
        Sys.println("c");
        MapView.setScreenVisibleArea(0, 0, System.getDeviceSettings().screenWidth, System.getDeviceSettings().screenHeight / 2);
        Sys.println("d");
    }
    
    function updateMarkers()
    {
        return;
        
        Sys.println("update markers");
        // create a new polyline
        var polyline = new Ui.MapPolyline();

        // set the color of the line
        polyline.setColor(Gfx.COLOR_RED);

        // set width of the line
        polyline.setWidth(2);

        // add locations to the polyline
        for (var i = 0; i < 20; ++i)
        {
        polyline.addLocation(new Position.Location({:latitude => 38.85391, :longitude =>-94.79630, :format => :degrees}));
        polyline.addLocation(new Position.Location({:latitude => 38.85465, :longitude =>-94.79922, :format => :degrees}));
        polyline.addLocation(new Position.Location({:latitude => 38.85508, :longitude =>-94.79959, :format => :degrees}));
        polyline.addLocation(new Position.Location({:latitude => 38.85557, :longitude =>-94.79864, :format => :degrees}));
        polyline.addLocation(new Position.Location({:latitude => 38.85629, :longitude =>-94.79882, :format => :degrees}));
        polyline.addLocation(new Position.Location({:latitude => 38.85583, :longitude =>-94.79942, :format => :degrees}));
        polyline.addLocation(new Position.Location({:latitude => 38.85695, :longitude =>-94.80051, :format => :degrees}));
        }

        // add the polyline to the Map
        MapView.setPolyline(polyline);

        // create map markers array
        var map_markers = [];

        // create a map marker at a location on the map
        var marker = new Ui.MapMarker(new Position.Location({:latitude => 38.85391, :longitude =>-94.79630, :format => :degrees}));
        marker.setIcon(Ui.loadResource(Rez.Drawables.MapPin), 12, 24);
        marker.setLabel("Custom Icon");
        map_markers.add(marker);

        marker = new Ui.MapMarker(new Position.Location({:latitude => 38.85557, :longitude =>-94.79864, :format => :degrees}));
        marker.setIcon(Ui.loadResource(Rez.Drawables.MapPin), 12, 24);
        marker.setLabel("Custom Icon");
        map_markers.add(marker);

        marker = new Ui.MapMarker(new Position.Location({:latitude => 38.85508, :longitude =>-94.79959, :format => :degrees}));
        marker.setIcon(Ui.MAP_MARKER_ICON_PIN, 0, 0);
        marker.setLabel("Predefined Icon");
        map_markers.add(marker);

        // add map markers to the Map
        MapView.setMapMarker(map_markers);


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
        Sys.println("mapView: onUpdate");
        MapView.onUpdate(dc);
        return;
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(
                    dc.getWidth() / 2,                      // gets the width of the device and divides by 2
                    dc.getHeight() / 2 - 40,                     // gets the height of the device and divides by 2
                    Gfx.FONT_LARGE,                    // sets the font size
                    (Sys.getSystemStats().usedMemory / 1024).toNumber(),
                    Gfx.TEXT_JUSTIFY_CENTER            // sets the justification for the text
                  );
        dc.drawText(
                    dc.getWidth() / 2,                      // gets the width of the device and divides by 2
                    dc.getHeight() / 2+40,                     // gets the height of the device and divides by 2
                    Gfx.FONT_LARGE,                    // sets the font size
                    "transparent",
                    Gfx.TEXT_JUSTIFY_CENTER            // sets the justification for the text
                  );
    }
}
