using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;

var fLimitedMem = (Sys.getSystemStats().totalMemory < 48000);
var strDistUnit = (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC) ? "m" : "yd";
var strOdomUnit = (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC) ? "km" : "mi";

const FloatMax =  3.40282347E38.toFloat();
const FloatMin = -3.402823E38.toFloat();
const IntMax = 2147483647;
const IntMin = -2147483648;
const Pi = Math.PI.toFloat();

//--- Unit/conversion constants
const MetersPerMile = 1609.344;
const YdPerMile = 1760;
const FtPerMeter = 3.28084;
const YdPerMeter = 1.09361;
const MeterSec2MiHr = MetersPerMile/3600.0;
const MeterSec2MiMin = MetersPerMile/60.0;

//--- Globals------------------------------------
//var distFactor = (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC) ? 1.0 : YdPerMeter;
var fMetric = (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC);
var odomFactor = fMetric ? 1000 : YdPerMile;
var strDistUnits = fMetric ? "meters" : "yards";
var strDistUnitsMin = fMetric ? "m" : "yd";
var strDistUnitsMiKm = fMetric ? "km" : "mi";
var ydmDistCvt = fMetric ? 1 : YdPerMeter;
var kmmiDistCvt = fMetric ? 1000 : MetersPerMile;

function absVal(a) {return((a < 0) ? -a : a);}
function minVal(a,b) {return((a < b) ? a : b);} //assumes good inputs
function maxVal(a,b) {return((a > b) ? a : b);} //assumes good inputs

//-----------------------------------------------------
function strTimeOfDay()
{
    var clockTime = Sys.getClockTime();
    return(Lang.format("$1$:$2$:$3$",[clockTime.hour % 24, clockTime.min.format("%02d"),clockTime.sec.format("%02d")]));
}
//-----------------------------------------------------
// ms to [[hh:]m]m:ss
function strDur(time)
{
    if (time==null) {return("--");}

    var tm = (time / 1000).toNumber();
    var hours = (tm / (60 * 60)).toNumber();
    var minutes = ((tm % (60*60)) / 60).toNumber();
    var seconds = (tm % 60).toNumber();
    var strTime;
    if (hours > 0)
    {
        strTime = hours +":" + minutes.format("%02u")+":"+seconds.format("%02u");
    }
    else
    {
        strTime = minutes.format("%u")+":"+seconds.format("%02u");
    }
    return(strTime);
}

//-----------------------------------------------------
function strAlt(mtr) {return((mtr != null) ? (mtr * FtPerMeter).format("%d") : "--");}

//-----------------------------------------------------
function strDist(dist) //in meters 
{
    if (dist == null) {return("--");}
    dist /= kmmiDistCvt;      
    return(dist.format("%.2f"));
}

//---------------------------------
//returns distance in meters
//lat/lon in radians
const earthR = 6371e3; //earth's radius in meters
const SCtoRad = Pi / 2147483648.0; //rad=lat,lon * SCtoRad - 0.00000000146291811998
const RadtoMtr = 6356852.14; //at equater
var SCtoMtr =0.01157;//0.007524748;// 0.00933;// 40075000f/�?�4294967296f; //=0.0093306880444288 
function distCalc(lon1, lat1, lon2, lat2)
{
    //lon/lat
    var x = (lon2-lon1)*Math.cos((lat1+lat2)/2);
    var y = lat2-lat1;
    var d = Math.sqrt(x*x+y*y)*earthR; //meters
    return(d);
}
