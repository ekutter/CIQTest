using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.Activity as Act;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;

//--- Color constants
const ClrTrans = -1;//Gfx.COLOR_TRANSPARENT;
const ClrLtGray = 0xAAAAAA;//Gfx.COLOR_LT_GRAY;
const ClrGray = 0x888888;
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

//extended colors
const ClrPurple = 0xAA00FF;
const ClrDkPurple = 0x5500AA;//0xAA00FF;

enum {F0, F1, F2, F3, F4,FN0, FN1, FN2, FN3, FX1, FX2}
enum {JR, JC, JL, JVC=4, JCC=5, JCORE=7} //justify

//---------------------------------------------------------
//---------------------------------------------------------
class Rect
{
    var x0, x1, y0, y1; //bounding box
    function initialize(x0_, y0_, x1_, y1_)
    {
        x0 = x0_;
        y0 = y0_;
        x1 = x1_;
        y1 = y1_;
    }
    function isEmpty() {return((x0 == x1) || (y0 == y1));}
    function contains(x,y,c) {return((x >= x0-c) && (x <= x1+c) && (y >= y0-c) && (y <= y1+c));}
    function width() {return(x1 - x0);}
    function height() {return(y1 - y0);}
    function wellOrder()
    {
        if (x0 > x1) {var x=x0; x0=x1; x1=x;}
        if (y0 > y1) {var y=y0; y0=y1; y1=y;}
    }
    function toStr(str) {return(Lang.format("$1$: $2$, $3$, $4$, $5$",[str,x0,y0,x1,y1]));}
    function print(str)
    {
        Sys.println(Lang.format("$1$: $2$, $3$, $4$, $5$",[str,x0,y0,x1,y1]));
    }
    function draw(dc,clr)
    {
        dc.setColor(clr,clr);
        dc.drawRectangle(x0,y0,width(),height());
    }
}

//---------------------------------
function fillCircle(dc,x,y,r,clr) {dc.setColor(clr,clr);dc.fillCircle(x,y,r);}

//---------------------------------
function drawPolyline(dc,rgx,rgy,cPt,clr,penWidth)
{
    dc.setColor(clr,clr);
    dc.setPenWidth(penWidth);
    var x0 = rgx[0];
    var y0 = rgy[0];
    for (var i = 1; i < cPt; ++i)
    {
        var x1 = rgx[i];
        var y1 = rgy[i];
        dc.drawLine(x0,y0,x1,y1);
        x0 = x1;
        y0 = y1;
    }
}
//---------------------------------
// x,y - center
// c - total height
// hdg - radians - 0=N, Pi/2=E
function drawHdgArrow(dc, x, y, c, hdg, clrFg, clrBg)
{
    var dir = hdg-Pi/2; //0=right
    //angle/len
    var rgA = [0.0,0.5, Pi*0.8,0.5, Pi,0.2, Pi*1.2,0.5];

    var rgpt = new [5];
    for (var i = 0; i < 4; ++i)
    {
        var pt = new [2];
        pt[0] = (Math.cos(dir+rgA[i*2])*(c*rgA[i*2+1])+x).toNumber();
        pt[1] = (Math.sin(dir+rgA[i*2])*(c*rgA[i*2+1])+y).toNumber();
        rgpt[i] = pt;
    }
    rgpt[4]=rgpt[0];
    //Sys.println(rgpt.toString());

    dc.setPenWidth(1);
    dc.setColor(clrBg,clrBg);
    dc.fillPolygon(rgpt);

    dc.setColor(clrFg,clrFg);
    for (var i = 0; i < 4; ++i)
    {
        dc.drawLine(rgpt[i][0],rgpt[i][1],rgpt[i+1][0],rgpt[i+1][1]);
    }
}
//---------------------------------
// adjust the heading for your current heading
// all are radians, N=up
function currentHeading()
{
    var info = Act.getActivityInfo();
    return(((info != null) && (info.currentHeading != null)) ? info.currentHeading : 0);
}
