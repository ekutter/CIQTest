using Toybox.Ant;
using Toybox.Time;
using Toybox.System as Sys;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class SensorSimple extends Ant.GenericChannel 
{
    //---------------------------------
    static enum {    //devtype, period
        DEV_TEMPE,   //=25, 65535 or 8192
        DEV_TRACKER, //=41, 2048
        DEV_HR,      //=120, 8070
        DEV_FOOTPOD, //=124, 16268
        }

    static var rgDevType = [25,41,120,124];
    static var rgDevName = ["Tempe","Tracker","HR","FootPod"];
    static var rgDevPeriod = [65535,2048,8070,16268];

    hidden var chanAssign;

    var searching;
    var deviceCfg;
    
    var idSearch;
    var antid=0;
    var cMsg = 0;

    //-----------------------------------------------------
    function initialize(iDevType) 
    {
        addMsg("Sensor - " + rgDevName[iDevType]);
        idSearch = 0;

        // Get the channel
        chanAssign = new Ant.ChannelAssignment(
            Ant.CHANNEL_TYPE_RX_NOT_TX, //!!!0
            Ant.NETWORK_PLUS);
        GenericChannel.initialize(method(:onMessage), chanAssign);

        var iTimeout = (30000 / 2.5 / 1000).toNumber()-1;
        Sys.println("iTimeout: " + iTimeout);

        // Set the configuration
        deviceCfg = new Ant.DeviceConfig( {
            :deviceNumber => idSearch,                 //Wildcard our search
            :deviceType => rgDevType[iDevType],
            :transmissionType => 0,
            :messagePeriod => rgDevPeriod[iDevType],
            :radioFrequency => 57,              //Ant+ Frequency
            :searchTimeoutLowPriority => iTimeout,    //Timeout in 25s
            :searchThreshold => 0} );           //Pair to all transmitting sensors
        GenericChannel.setDeviceConfig(deviceCfg);

        searching = true;
        open();
    }

    //-----------------------------------------------------
    function strStatus()
    {
        if (searching) {return("searching");}
        else {return(cMsg+"");}
    }
    
    //-----------------------------------------------------
    function open() 
    {
        // Open the channel
        var fSuccess = GenericChannel.open();
        searching = true;
        addMsg("open=" + fSuccess);
    }

    //-----------------------------------------------------
    function closeSensor() 
    {
        addMsg("closeSensor");
        GenericChannel.close();
    }

    //-----------------------------------------------------
    function onMessage(msg) 
    {
        //addMsg("onMessage");
        // Parse the payload
        var payload = msg.getPayload();

        if( Ant.MSG_ID_BROADCAST_DATA == msg.messageId ) 
        {
            if (searching) 
            {
                searching = false;
                // Update our device configuration primarily to see the device number of the sensor we paired to
                deviceCfg = GenericChannel.getDeviceConfig();
                antid = msg.deviceNumber;
                addMsg("connected: " + antid);
            }
            cMsg = (cMsg + 1) %1000;
        } 
        else if(Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId) 
        {
            if (Ant.MSG_ID_RF_EVENT == (payload[0] & 0xFF)) 
            {
                if (Ant.MSG_CODE_EVENT_CHANNEL_CLOSED == (payload[1] & 0xFF)) 
                {
                    addMsg("closed");
                    // Channel closed, re-open
                    open();
                } 
                else if( Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH  == (payload[1] & 0xFF) ) 
                {
                    addMsg("go to search");
                    searching = true;
                }
            } 
            else 
            {
                //It is a channel response.
            }
        }
    }

}