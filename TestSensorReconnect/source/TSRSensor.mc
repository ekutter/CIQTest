using Toybox.System as Sys;
using Toybox.Ant as Ant;

enum {SNS_HR, SNS_TRACKER, SNS_FP, SNS_POWER, SNS_COUNT}
//-----------------------------------------------
//-----------------------------------------------
class TestSensor
{
    var idSensorCur = 0; //the one currently found and being viewed
    var idSensorRequested = 0;    //requested

    //-------------------------------------------------------------------------
    var antChannel; //Ant.GenericChannel
    var searching = false;
    
    //these must match the order
    var sns;
    var rgType = [120,41,124,11];
    //var rgPeriod = [16268,2048,16268,32768];
    var rgPeriod = [8070,2048,8134,4091];
    //HR 8070, 16140, or 32768
    //power 4091, 8182, or 32768
    //fp 8134 or 32768
    
    
    static var rgName = ["HR","TRACKER", "FootPod", "Power"];

    //---------------------------------
    function initialize(id, snsIn)
    {
        sns = snsIn;
        initSensor(id);
    }
    //---------------------------------
    function initSensor(idSensorIn)
    {
        try
        {
            Sys.println("initSensor("+idSensorIn+","+rgName[sns]+"): ");
            closeSensor(); //release the channel if it's not null
            idSensorRequested = idSensorIn;
            idSensorCur = null;

            var chanAssign = new Ant.ChannelAssignment(Ant.CHANNEL_TYPE_RX_NOT_TX,Ant.NETWORK_PLUS);
            antChannel = new Ant.GenericChannel(method(:onMessage), chanAssign);
    
            // Set the configuration
    
            var deviceCfg = new Ant.DeviceConfig( {
                :deviceNumber => idSensorRequested, //0==Wildcard our search
                :deviceType => rgType[sns], //tracker profile
                :transmissionType => 0,
                :messagePeriod => rgPeriod[sns],
                :radioFrequency => 57,             //Ant+ Frequency
                :searchTimeoutLowPriority => 10,    //Timeout in 2.5s
                :searchTimeoutHighPriority => 0,    // Timeout in 2.5s
                :searchThreshold => 0} );          //Pair to all transmitting sensors
            antChannel.setDeviceConfig(deviceCfg);

            antChannel.open();
            searching = true;
            
        } catch (ex)
        {
            Sys.println("Tracker: Exception adding Ant+ sensor: " + ex.getErrorMessage());
            searching = true;
        }
    }

    //---------------------------------
    function closeSensor()
    {
        if (antChannel != null) 
        {
            Sys.println("CloseSensor: ");
            antChannel.release();
            antChannel = null;
        }
    }

    //---------------------------------
    // just minimal reset;
    function resetSensor(idSensorIn)
    {
        Sys.println("resetSensor: " + idSensorIn);
        initSensor(idSensorIn);
    }

    //---------------------------------
    function onMessage(msg)
    {
        var payload = msg.getPayload();

        if( Ant.MSG_ID_BROADCAST_DATA == msg.messageId )
        {
            if (searching)
            {
                searching = false;
                idSensorCur = msg.deviceNumber & 0xffff; //only low 16 bits matter
                Sys.println("Sensor found id=" + idSensorCur);

                var deviceCfg = antChannel.getDeviceConfig();
                if (deviceCfg.deviceNumber != idSensorCur)
                {
                    Sys.println("Connected ID doesn't match deviceCFG ID: " + deviceCfg.deviceNumber);
                }
            }
        }
        else if(Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId)
        {
            if (Ant.MSG_ID_RF_EVENT == (payload[0] & 0xFF))
            {
                if (Ant.MSG_CODE_EVENT_CHANNEL_CLOSED == (payload[1] & 0xFF))
                {
                    // Channel closed, re-open - we don't care for this test case
                    Sys.println("MSG_CODE_EVENT_CHANNEL_CLOSED ******* "+ idSensorCur);
                    //initSensor(idSensorRequested);
                }
                else if( Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH  == (payload[1] & 0xFF) )
                {
                    Sys.println("Tracker: event FAIL - back to search");
                    searching = true;
                }
            }
        }
    }
}