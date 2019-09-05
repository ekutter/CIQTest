using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.Lang as Lang;

//-----------------------------------------------------------------------------

class LogMsg
{
    static var devID = Sys.getDeviceSettings().uniqueIdentifier.substring(0,4);
    static var appName = Ui.loadResource(Rez.Strings.AppName);
    var fSendMsg = false;
    const cMaxMsg = 10;
    var cMsg=0; //total number of messages sent
    var iFirstMsg = 0;
    var iNextMsg  = 0;
    var rgMsgQueue = new [cMaxMsg];
    var fResponsePending = false;

    //-----------------------------------------------------
    function initialize(f)
    {
        fSendMsg = f;
        logMsg(Lang.format("starting $1$ $2$",[LogMsg.appName, LogMsg.devID]));
        logMsg("Sys.getTimer(): " + Sys.getTimer());
    }
    
    //-----------------------------------------------------
    function logMsg(msg)
    {
        cMsg++; 
        Sys.println(msg);
        if (fSendMsg)
        {
            msg = cMsg + ", " + strTimeOfDay(true) + ", " + msg;
               
           //have we wrapped? Overwrite the first one
           rgMsgQueue[iNextMsg] = msg;
           iNextMsg = (iNextMsg+1)%cMaxMsg;

           //have we wrapped? Overwrite the first one
           if (iFirstMsg == iNextMsg) {iFirstMsg = (iFirstMsg + 1) % cMaxMsg;}
           
           sendNextMsg();
        }          
    }
    //-----------------------------------------------------
    function sendNextMsg()
    {
        //Sys.println(Lang.format("sendNextMsg[$1$,$2$], fPend=$3$",[iFirstMsg,iNextMsg,fResponsePending])); 
        if (!fResponsePending)
        {
            var msg = rgMsgQueue[iFirstMsg]; 
            if (msg != null)        
            {
                //Sys.println("   " + msg);
                rgMsgQueue[iFirstMsg] = null;
                iFirstMsg = (iFirstMsg+1)%cMaxMsg;
                Comm.makeWebRequest(
                    "https://mtyquinn.com/MyHouse/HandlerWSSrv.ashx/Api/CIQInfo",
                    {"id"=>devID,  
                     "app"=>appName,
                     "info"=>msg},
                    {"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED},method(:onNewData));
                fResponsePending=true;
            }
        }     
    }
    
    //-----------------------------------------------------
    function onNewData(responseCode, data)
    {
        fResponsePending = false;
        if ((responseCode != 200) && (responseCode != -400))
        {
           Sys.println("onNewData error:" + responseCode);
        }
        sendNextMsg();
    }
}
