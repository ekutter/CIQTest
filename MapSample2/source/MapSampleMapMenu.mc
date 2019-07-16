using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class MapSampleMapMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if( item == :menu_0 ) {
            Sys.println("menu_0");
        }
        if( item == :menu_1 ) {
            Sys.println("menu_1");
        }
    }
}