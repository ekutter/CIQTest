using Toybox.WatchUi;

class TestAntConnectionDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new TestAntConnectionMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}