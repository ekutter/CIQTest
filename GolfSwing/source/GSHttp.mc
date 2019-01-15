using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Communications as Comm;
using Toybox.Time as Time;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Attention as Att;

class HttpData
{
    var errcode;
    var fPending = false;
    var iSend = 0;

    //-------------------------------------------
    function initialize()
    {
    }
    //-----------------------------------------------
    function onNewData(responseCode, data)
    {
        fPending = false;
        if (responseCode == 200)
        {
            errcode = null;
            Sys.println("httpResponse: " + data);
            if (data["ws"] != null)
            {
            }
        }
        else
        {
            //iv'e seen
            // BLE_HOST_TIMEOUT = -2
            // BLE_CONNECTION_UNAVAILABLE = -104
            // INVALID_HTTP_BODY_IN_NETWORK_RESPONSE = -400
            // NETWORK_REQUEST_TIMED_OUT = -300
            //Sys.println("onNewData: responseCode="+responseCode);
            errcode = responseCode;
        }
        Ui.requestUpdate();
    }
    //-----------------------------------------------
    function sendDataRequest(cmd,data)
    {
        Sys.println("sendData: " + data);
//        data = "";
//        for (var i = 0; i < 2000;++i)
//        {
//            data += "1";
//        }
        
        if (Sys.getDeviceSettings().phoneConnected)
        {
            errcode = null;
           
            var id = Sys.getDeviceSettings().uniqueIdentifier.substring(0,16);
            //var data = "data"; 
            Comm.makeWebRequest(
                "https://yourserver.com/WebSite/HandlerWSSrv.ashx/Api/CIQAccelData",
                {"id"=>id, "cmd"=>cmd, "data"=>data}, 
                {"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED},
                method(:onNewData));
            fPending = true;
            iSend += 1;
            Ui.requestUpdate();
        }
    }
}