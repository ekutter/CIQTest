using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;


const IntMax = 2147483647;
const IntMin = -2147483648;

function minVal(a,b) {return((a < b) ? a : b);} //assumes good inputs
function maxVal(a,b) {return((a > b) ? a : b);} //assumes good inputs
function toChar(number) {return number.toChar();}

const ClrTrans = -1;//Gfx.COLOR_TRANSPARENT;
const ClrLtGray = 0xAAAAAA;//Gfx.COLOR_LT_GRAY;
const ClrDkGray = 0x555555;//Gfx.COLOR_DK_GRAY;
const ClrWhite = 0xFFFFFF;//Gfx.COLOR_WHITE;
const ClrBlack = 0x000000;//Gfx.COLOR_BLACK;
const ClrBlue = 0x00AAFF;//Gfx.COLOR_BLUE;
const ClrDkBlue = 0x0000FF;//Gfx.COLOR_DK_BLUE;
const ClrDkRed = 0xAA0000;//Gfx.COLOR_DK_RED;
const ClrRed = 0xFF0000;
const ClrDkGreen = 0x00AA00;//Gfx.COLOR_DK_GREEN;
const ClrGreen = 0x00FF00;//Gfx.COLOR_GREEN;
const ClrYellow = 0xFFAA00; //Gfx.COLOR_YELLOW;

enum {F0, F1, F2, F3, F4,FN0, FN1, FN2, FN3, FX1, FX2}

//-----------------------------------------------------
function strTimeOfDay(fLong)
{
    var clockTime = Sys.getClockTime();
    var hour, min, result;
    if (Sys.getDeviceSettings().is24Hour)
    {
        hour = clockTime.hour % 24;
    }
    else
    {
        hour = clockTime.hour % 12;
        hour = (hour == 0) ? 12 : hour;
    }
    min = clockTime.min;

    var str = Lang.format("$1$:$2$",[hour, min.format("%02d")]);

    if (fLong)
    {
        //var ampm = (clockTime.hour < 12) ? "a" : "p";
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

//-----------------------------------------------
function logMsg(str)
 {
    var clockTime = Sys.getClockTime();
    var strTime = Lang.format("$1$:$2$:$3$",[clockTime.hour % 24, clockTime.min.format("%02d"),clockTime.sec.format("%02d")]);
    Sys.println(Lang.format("$1$: $2$",[strTime,str]));
}
