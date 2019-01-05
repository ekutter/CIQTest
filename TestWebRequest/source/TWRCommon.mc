using Toybox.System as Sys;
using Toybox.Lang as Lang;

//-----------------------------------------------------
// get the time of day - fLong=true includes seconds
function strTimeOfDay(fLong)
{
    var clockTime = Sys.getClockTime(); 
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
