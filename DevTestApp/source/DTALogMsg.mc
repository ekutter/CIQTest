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
//        var fw = Sys.getDeviceSettings().firmwareVersion;
                
        logMsg("-------  STARTING   ----------");                  
        logMsg(LogMsg.appName);                 
        logMsg(strDate()); 
        logMsg("Sys.getTimer(): " + Sys.getTimer());
        
        var settings = Sys.getDeviceSettings();
        var stats = Sys.getSystemStats();
        var s;

        //these are basically identical to what gets displayed on the home screen
        logMsg(Lang.format("p#: $1$", [settings.partNumber])); 
        logMsg(Lang.format("id: $1$", [settings.uniqueIdentifier.substring(0,16)])); 
        
        logMsg(Lang.format("mem: $1$k/$2$k - $3$k",
            [stats.usedMemory/1024, 
             stats.totalMemory/1024,
             stats.freeMemory/1024]));

        var ver = settings.monkeyVersion;
        logMsg(Lang.format("fw=$1$.$2$", 
            [settings.firmwareVersion[0],settings.firmwareVersion[1].format("%2.2d")]));

        logMsg(Lang.format("CIQ=$1$.$2$.$3$",ver)); 

        logMsg(Lang.format("touch: $1$ btns: $2$", [settings.isTouchScreen ? "Y" : "N",settings.inputButtons])); 
        logMsg(Lang.format("scr: $1$,$2$",[cxScreen,cyScreen]));
        logMsg("bat: " + stats.battery.format("%0.0f"));
        logMsg("-------------------------------");
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
