using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Ant as Ant;
using Toybox.Time as Time;
using Toybox.Lang as Lang;
using Toybox.Attention as Att;
using Toybox.Position as Position;

class TestSensor
{
    var idSensorCur = 0; //the one currently found and being viewed
    var idSensorRequested = 0;    //requested

    //-------------------------------------------------------------------------
    var antChannel; //Ant.GenericChannel
    var searching = false;

    //---------------------------------
    function initialize(id)
    {
        initSensor(id);
    }
    //---------------------------------
    function initSensor(idSensorIn)
    {
        try
        {
            logMsg("initSensor("+idSensorIn+"): ");
            closeSensor(); //release the channel if it's not null
            idSensorRequested = idSensorIn;
            idSensorCur = null;

            var chanAssign = new Ant.ChannelAssignment(Ant.CHANNEL_TYPE_RX_NOT_TX,Ant.NETWORK_PLUS);
            antChannel = new Ant.GenericChannel(method(:onMessage), chanAssign);
    
            // Set the configuration
    
            var deviceCfg = new Ant.DeviceConfig( {
                :deviceNumber => idSensorRequested, //0==Wildcard our search
                :deviceType => 41, //tracker profile
                :transmissionType => 0,
                :messagePeriod => 2048,
                :radioFrequency => 57,             //Ant+ Frequency
                :searchTimeoutLowPriority => 10,    //Timeout in 2.5s
                :searchTimeoutHighPriority => 0,    // Timeout in 2.5s
                :searchThreshold => 0} );          //Pair to all transmitting sensors
            antChannel.setDeviceConfig(deviceCfg);

            antChannel.open();
            searching = true;
            
        } catch (ex)
        {
            logMsg("Tracker: Exception adding Ant+ sensor: " + ex.getErrorMessage());
            searching = true;
        }
    }

    //---------------------------------
    function closeSensor()
    {
        if (antChannel != null) 
        {
            logMsg("CloseSensor: ");
            antChannel.release();
            antChannel = null;
        }
    }

    //---------------------------------
    // just minimal reset;
    function resetSensor(idSensorIn)
    {
        logMsg("resetSensor: " + idSensorIn);
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
                logMsg("Tracker - tracker found: " + idSensorCur);

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
                    logMsg("MSG_CODE_EVENT_CHANNEL_CLOSED ******* "+ idSensorCur);
                }
                else if( Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH  == (payload[1] & 0xFF) )
                {
                    logMsg("Tracker: event FAIL - back to search");
                    searching = true;
                }
            }
        }
    }
}