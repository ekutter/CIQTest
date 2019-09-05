using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

//---------------------------------------------------------
//---------------------------------------------------------
class TestWebRequestApp extends App.AppBase 
{
    const DurUpdScreen = 1 * 1000;       //TimerTic every second
    var timer = new Timer.Timer();
    var delegate;
    var view;
    var mem;

    //---------------------------------
    function initialize() 
    {
        //just take up some memory to see if that helps
//        mem = new [100];
//        for (var i = 0; i < mem.size(); ++i)
//        {
//            mem[i] = new[210];
//        }
        
        AppBase.initialize();
        Sys.println("\nstarting TestWebRequest: " + strTimeOfDay(true)); //log when we started
        timer.start(method(:onTimerTic),DurUpdScreen,true);
    }

    //---------------------------------
    function onTimerTic() //every second
    {
        view.onTimerTic();
    }

    //---------------------------------
    function onStart(x){}

    //---------------------------------
    function onStop(x)
    {
        Sys.println("RunTime: " + strDur(Sys.getTimer() - view.tmStart));
        Sys.println("total successful responses: " + view.cResponse);
        Sys.println("errors: " + view.cErr);
        Sys.println("time last Success: " + view.strLastSuccess);
        Sys.println("boot time to last success: " + strDur(view.tmLastSuccess));
        Sys.println("boot time: " + strDur(Sys.getTimer()));
        Sys.println("Req Int: " + view.cReqInt);
    }

    //---------------------------------
    function getInitialView() 
    {
        view = new TestWebRequestView();
        delegate = new TestWebRequestDelegate(view) ;
        return [ view, delegate];
    }

}
