using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Lang as Lang;
using Toybox.Application as App;

//-----------------------------------------------------
const FtPerMeter = 3.28084;


//-----------------------------------------------------
(:background)
function strTimeOfDay(fLong){return(strTime(Sys.getClockTime(),fLong));}

(:background)
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
(:background)
function logMsg(str)
{
    Sys.println(Lang.format("$1$: $2$",[strTimeOfDay(true),str]));
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
    else //if (hours > 0)
    {
        strTime = hours +":" + minutes.format("%02u")+":"+seconds.format("%02u");
    }
    //else
    // {
    //    strTime = minutes.format("%u")+":"+seconds.format("%02u");
    //}
    return(strTime);
}
//-----------------------------------------------------
// ms to [[hh:]m]m
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
