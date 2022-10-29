using Toybox.WatchUi;
using Toybox.SensorHistory as Hist;
using Toybox.System as Sys;

const MetersPerMile = 1609.344;
const YdPerMile = 1760.0;
const FtPerMeter = 3.28084;
const YdPerMeter = 1.09361;
const MeterSec2MiHr = MetersPerMile/3600.0;
const MeterSec2MiMin = MetersPerMile/60.0;
function MinPerMi(spd) {return(MeterSec2MiMin/spd);}

class BasicCIQFldView extends WatchUi.SimpleDataField 
{
    function initialize() 
    {
        SimpleDataField.initialize();
        label = "Instant Pace";
    }

    function compute(info) 
    {
        // See Activity.Info in the documentation for available information.
        Sys.println(info.currentSpeed);

        if ((info == null) || 
            (info.currentSpeed==null) ||
            (info.currentSpeed==0)) 
        {
            return("--");
        }
        var pace = MinPerMi(info.currentSpeed);
        if (pace > 99.9) {return("99.9");}
        var a = pace.toNumber();
        var b = pace - a;
        var str = a + ":" + (b * 60).format("%02u");
        return(str);
    }

}