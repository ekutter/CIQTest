using Toybox.WatchUi;

class DevTestAppDelegate extends WatchUi.InputDelegate {

    function initialize() {
        InputDelegate.initialize();
    }
}

class DevTestAppView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) 
    {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() 
    {
        state.setPg(0);
    }

    // Update the view
    function onUpdate(dc) 
    {
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}



