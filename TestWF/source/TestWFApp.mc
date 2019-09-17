using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.Background;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
var OSDATA="osdata";

var fCanDoBG=false;
var fInBackground=false;    

var bgdata=null;
var wsdata = null;
var lights=0;
var fGrgDrOpen=false;  //these get reset if no data for too long
var fFireplace=false;

const fTestWebRequest = true;

(:background)
class WF1App extends App.AppBase {

    //-----------------------------------------------------
    function initialize() 
    {
        AppBase.initialize();
        logMsg(Lang.format("TestWF App initializev v1.0, testwebrequest=$1$",[fTestWebRequest]));
    }

    //-----------------------------------------------------
    function onStart(state) 
    {
        logMsg("onStart: fInBG =" + fInBackground);
    }

    //-----------------------------------------------------
    //only gets called at the ver end, by the main process, not background
    function onStop(state) 
    {
        logMsg("onStop: fInBG =" + fInBackground);
//        if(!fInBackground) 
//        {
//            logMsg("onStop");    
//        }
    }

    //-----------------------------------------------------
    function getInitialView() 
    {
        logMsg("FG: getInitView");
        if(Toybox.System has :ServiceDelegate) 
        {
            fCanDoBG=true;
            Background.registerForTemporalEvent(new Time.Duration(5 * 60)); //every 5 minutes
        } else {
            Sys.println("****background not available on this device****");
        }
        
        if( Toybox.WatchUi.WatchFace has :onPartialUpdate ) 
            {return([ new WF1View(), new WF1Delegate() ]);}
        else
            {return ([ new WF1View() ]);}
    }
    //-----------------------------------------------------
    function onBackgroundData(data) 
    {
        var str;
        cBG++;
        bgdata=data;
        if ((data != null) && (data["ws"] != null) && (data["ws"].size() > WS_LTS))
        {
            wsdata = data["ws"];
            str = wsdata;
        }
        else
        {
            wsdata = null;
            str = "no WS data";
        }
        logMsg("onBackgroundData="+str);
        App.getApp().setProperty(OSDATA,bgdata);
        Ui.requestUpdate();
    }    
    //-----------------------------------------------------
    function getServiceDelegate()
    {
        logMsg("getServiceDelegate");
        return [new WF1BgServiceDelegate()];
    }
}
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
(:background)
class WF1BgServiceDelegate extends Toybox.System.ServiceDelegate {
    
    //-----------------------------------------------------
    var http;
    function initialize() 
    {
        logMsg("background: BgServiceDelegate - init");
        Sys.ServiceDelegate.initialize();
        fInBackground=true;             //trick for onExit()
        http = new HttpData();
        http.sendDataRequest();
    }
    
    //-----------------------------------------------------
    function onTemporalEvent() 
    {
        logMsg("background:onTemporalEvent");
        //Background.exit(null);
    }
}
