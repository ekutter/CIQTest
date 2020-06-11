using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Attention as Att;
using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.Time.Gregorian as Calendar;


const FloatMax =  3.40282347E38.toFloat();
const FloatMin = -3.402823E38.toFloat();
const IntMax = 2147483647;
const IntMin = -2147483648;
const Pi = Math.PI.toFloat();
//const DegreeSym="°";//same as 176.toChar(), 0xb0 but need to set file to UTF-8

//--- Unit/conversion constants
const MetersPerMile = 1609.344;
const YdPerMile = 1760.0;
const FtPerMeter = 3.28084;
const YdPerMeter = 1.09361;
const MeterSec2MiHr = MetersPerMile/3600.0;
const MeterSec2MiMin = MetersPerMile/60.0;

function Ft2Meter(ft) {return(ft / FtPerMeter);}
function MinPerMi(spd) {return(MeterSec2MiMin/spd);}
function MiPerHr(spd) {return(spd / MeterSec2MiHr);}

const distFactor = YdPerMeter; //watch app is all in yards

//--- Globals------------------------------------
enum {TIMER_OFF, TIMER_STOPPED, TIMER_PAUSED, TIMER_ON} //paused only happens in autopause
var rgstrTimerState = ["OFF","STOPPED","PAUSED","ON"];

//-----------------------------------------------------
//dutycycle, length (ms)
// lvl: 0-100
// dur: ms
function vibrate(lvl,dur)
{
    if (Att has :vibrate)
        {Att.vibrate([new Att.VibeProfile(  lvl,dur)]);}
}

//-----------------------------------------------------
// 0-17, -1==no tone
function tone(iTone)
{                                    
    if ((iTone != -1) && (Att has :playTone))
        {Att.playTone(iTone % 18);}
}

//-----------------------------------------------------

function strTimeOfDay(fLong){return(strTime(Sys.getClockTime(),fLong));}
function strTime(clockTime,fLong)
{    
    var hour, min, result;

    hour = clockTime.hour % 12;
    hour = (hour == 0) ? 12 : hour;
    min = clockTime.min;

    var str = Lang.format("$1$:$2$",[hour, min.format("%02d")]);

    if (fLong)
    {
        var ampm = (clockTime.hour < 12) ? "a" : "p";
        str = str + Lang.format(":$1$",[clockTime.sec.format("%02d")]);
    }
    return (str);
}

//-----------------------------------------------------
function strDate()
{
    var now = Time.now();
    var tminfo = Calendar.info(now,Time.FORMAT_SHORT);
    var tminfoL = Calendar.info(now,Time.FORMAT_LONG);
    return(Lang.format("$1$ $2$-$3$-$4$ $5$:$6$:$7$",
        [tminfoL.day_of_week,tminfo.month,tminfo.day,tminfo.year,
        //1,2,3]));
        tminfo.hour,tminfo.min.format("%02d"),tminfo.sec.format("%02d")]));
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
    if (hours > 99)
    {
        var days = (hours / 24).toNumber();
        hours = hours % 24;
        strTime = days + "d" + hours.format("%02u") + ":" + minutes.format("%02u");
    }
    else if (hours > 0)
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
// ms to [[hh:]m]m:ss
function strDurMin(time)
{
    if (time==null) {return("--");}

    var tm = (time / 1000).toNumber();
    var hours = (tm / (60 * 60)).toNumber();
    var minutes = ((tm % (60*60)) / 60).toNumber();
    var seconds = (tm % 60).toNumber();
    var strTime;
    if (minutes>9)//(hours > 0)
    {
        strTime = hours +":" + minutes.format("%02u");//+":"+seconds.format("%02u");
    }
    else
    {
        strTime = minutes.format("%u")+":"+seconds.format("%02u");
    }
    return(strTime);
}
//-----------------------------------------------------
// ms to [[hh:]m]m:ss
function strDurHMS(time)
{
    if (time==null) {return("--");}

    var tm = (time / 1000).toNumber();
    var hours = (tm / (60 * 60)).toNumber();
    var minutes = ((tm % (60*60)) / 60).toNumber();
    var seconds = (tm % 60).toNumber();
    var strTime;
    strTime = hours +":" + minutes.format("%02u")+":"+seconds.format("%02u");
    return(strTime);
}

//-----------------------------------------------------
function strTemp(temp)
{
    if (temp==null){return("");}
    var str = (temp*9/5+32).format("%.0f")+"°";
    return(str);
}

//-----------------------------------------------------
function strAlt(mtr) {return((mtr != null) ? (mtr * FtPerMeter).format("%d") : "--");}
function strPwr(w) {return((w != null) ? w.format("%.0f") : "--");}
function strDist(mtr) {return((mtr != null) ? (mtr/MetersPerMile).format("%.2f") : "--");}
function strDist1(mtr) //single precision > 10mi
{
    var mi = mtr / MetersPerMile;
    return((mtr != null) ? (mi).format((mi >=10) ? "%.1f" : "%.2f") : "--");
}

//-----------------------------------------------------
// # < 999, meters or yards
// # > 999, km or mi in tenths
// add on symbol
function strOdom(dist)
{
    if (dist == null) {return("");}

    if (dist < 999)
    {
        return(dist.format("%.0f")+"yd");
    }
    else
    {
        return((dist / YdPerMile).format("%.1f")+"mi");
    }
}
//---------------------------------
//returns distance in meters
//lat/lon in radians
const earthR = 6371e3; //earth's radius in meters
const SCtoRad = Pi / 2147483648; //rad=lat,lon * SCtoRad
function distCalc(lon1, lat1, lon2, lat2)
{
    //lon/lat
    var x = (lon2-lon1)*Math.cos((lat1+lat2)/2);
    var y = lat2-lat1;
    var d = Math.sqrt(x*x+y*y)*earthR; //meters
    //Sys.println("x=" + x + ", y=" + y + ", dist=" + d);
    //Sys.println(Lang.format("[$1$,$2$,$3$,$4$]=$5$",
    //    [lon1,lat1,lon2,lat2,d]));

    //slightly more accurate version
    //var dd = 6371000.0d * Math.acos(Math.sin(lat1) * Math.sin(lat2) +
    //    Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon1 - lon2));
    //    Sys.println("dd="+dd);
    return(d);
}
//---------------------------------
function distCalc2(p0,p1)
{
    if ((p0 == null) || (p1 == null)) {return(0);}
    
    //!!may need to convert these to doubles?
    return(distCalc(p0[1],p0[0],p1[1],p1[0]));
}

//-----------------------------------------------
class StopWatch
{
    var tmStart;
    //---------------------------------
    function initialize()
    {
        tmStart = Sys.getTimer();
    }

    //---------------------------------
    function getTime()
    {
        //Sys.println("SW: " + tmStart + ", " + Sys.getTimer());
        return(Sys.getTimer() - tmStart);
    }
    
    //---------------------------------
    function toStr()
    {   
        return((getTime()/1000.0).format("%.3f"));
    }
}

//-----------------------------------------------------
//combine a list of strings as a single string, separated by 's'.
//function strJoin(rg,s)
//{
//    var sOut = "";
//    if (rg.size() > 0)
//    {
//        sOut = rg[0];
//        for (var i = 1; i < rg.size(); ++i)
//        {
//            sOut = s + rg[i];
//        }
//    }
//    return(sOut);
//}
