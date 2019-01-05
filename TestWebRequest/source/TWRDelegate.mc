using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

//---------------------------------------------------------
//---------------------------------------------------------
class TestWebRequestDelegate extends Ui.BehaviorDelegate 
{
    var view;
    //---------------------------------
    function initialize(view_) 
    {
        view = view_;
        BehaviorDelegate.initialize();
    }
}