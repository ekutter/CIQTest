using Toybox.Application;
using Toybox.WatchUi as Ui;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class TestInputApp extends Application.AppBase 
{

    //-------------------------------------------
    function initialize() 
    {
        AppBase.initialize();
    }

    //-------------------------------------------
    function getInitialView() 
    {
        return [ new TestInputView(), new TestInputDelegate() ];
    }

}
