using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.Background;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
var OSDATA="osdata";

var fCanDoBG=true;
var fInBackground=false;    

var wsdata = null;

const fTestWebRequest = true;

(:background)
class WF1App extends App.AppBase {

    //-----------------------------------------------------
    function initialize() 
    {
        AppBase.initialize();
        logMsg("App.init");
    }

    //-----------------------------------------------------
    function onStart(state) 
    {
        logMsg("App.onStart");
    }

    //-----------------------------------------------------
    //only gets called at the ver end, by the main process, not background
    function onStop(state) 
    {
        logMsg("App.onStop");
    }

    //-----------------------------------------------------
    function getInitialView() 
    {
        logMsg("App.getInitView");
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
        logMsg("App.onBackgroundData");
        cBG++;
        if ((data != null) && (data.size() > WS_LTS))
        {
            wsdata = data;
        }
        else
        {
            wsdata = null;
        }
        Ui.requestUpdate();
    }    
    //-----------------------------------------------------
    function getServiceDelegate()
    {
        fInBackground=true; //pretty sure this only gets called for background
   
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
        logMsg("ServiceDelegate.init");
        Sys.ServiceDelegate.initialize();
        fInBackground=true;             //trick for onExit()
        http = new HttpData();
        http.sendDataRequest();
    }
    
    //-----------------------------------------------------
    function onTemporalEvent() 
    {
        logMsg("ServiceDelegate.onTemporalEvent");
    }
}
