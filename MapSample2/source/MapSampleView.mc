using Toybox.WatchUi as Ui;

class MapSampleView extends Ui.View {

    private var mMenuPushed;

    function initialize() {
        View.initialize();
        mMenuPushed = false;
    }

    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        if( mMenuPushed == false ) {
            Ui.pushView(new Rez.Menus.MainMenu(), new MapSampleMenuDelegate(), Ui.SLIDE_UP);
            mMenuPushed = true;
        }
        else {
            Ui.popView(Ui.SLIDE_UP);
        }
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
