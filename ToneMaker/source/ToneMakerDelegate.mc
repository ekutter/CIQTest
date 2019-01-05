using Toybox.WatchUi;
using Toybox.Attention as Att;

var iTone = -1;
class ToneMakerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new ToneMakerMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    
    function onNextPage()
    {
        iTone = (iTone + 1) % 18;
        tone(iTone); 
        WatchUi.requestUpdate();
    }

    function onPreviousPage()
    {
        iTone = (iTone -1 + 18) % 18;
        tone(iTone);
        WatchUi.requestUpdate();
    }

	function tone(iTone)
	{                                    
	    if ((iTone != -1) && (Att has :playTone))
	        {Att.playTone(iTone % 18);}
	}

}