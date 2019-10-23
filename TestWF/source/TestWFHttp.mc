using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Communications as Comm;
using Toybox.Time as Time;
using Toybox.ActivityMonitor as ActMon;
using Toybox.Attention as Att;


//-----------------------------------------------
//these must match the values/order in WSSrv
enum {WS_TI1, WS_TI2, WS_TI3, WS_TI4, WS_TO1, WS_TO2, WS_TO3, WS_TO4,
      WS_WS, WS_WS10, WS_HI, WS_HO, WS_AQI, WS_LTS}

//these must match the order in WSSrv
enum {LtsValid, LtsGrgDr, LtsFire, LtsOfc, LtsLrFan, LtsLrE, LtsLrN, LtsLrW,
      LtsEntry, LtsDrive, LtsKitIsl, LtsKitCtr, LtsKitCans, LtsFrntDr,
      LtsGrg,LtsMBed,LtsFitHall,LtsFitRm, LtsFitBth, LtsFitPatio,
      LtsOutside, LtsGreatRm,LtsKitchen,
      LtsFitFan,LtsLrXMasOL,Ltsps_1,Ltsps_2,Ltsps_3,Ltswm_0,Ltswm_1,
      LtsGrgDrClose}

(:background)
class HttpData
{
    //-------------------------------------------
    function initialize()
    {
        logMsg("background: HttpData.init");
    }
    //-----------------------------------------------
    function onNewData(responseCode, data)
    {
        logMsg("background: onNewData");
        if (responseCode == 200)
        
        {
            logMsg("HTTP.onNewData");
            
        }
        else
        {
            logMsg("HTTP.onNewData: error=" + responseCode + ", " + data);
            data = null; 
        }
        Background.exit((data == null) ? null : data["ws"]);
    }

    var c = 0;
    //-----------------------------------------------
    function sendDataRequest()
    {
        logMsg("HTTP.sendDataRequest ph=" + Sys.getDeviceSettings().phoneConnected);
        if (!fTestWebRequest)
        {
            c++;
            //var data = Ui.loadResource(Rez.JsonData.testHTTP); //not working in current beta
            
            var data = [c, 70, 72, 66, 51, 51, 57, 68, 3, 3, 41, 90, 4, 1, 0];
            Background.exit(data);
        }
        else
        {
            var latlon = "m44.0330055,-121.3642440"; //bend
            Comm.makeWebRequest(
                "https://mtyquinn.com/MyHouse/HandlerWSSrv.ashx/Api/CIQInfo",
                {"id"=>"ericFR630", "steps"=>0,"cmd"=>"", "prev"=>0, 
                    "latlon"=>latlon}, 
                {"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED},
                method(:onNewData));
        }
    }
}