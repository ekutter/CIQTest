using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Activity as Act;

//--- Color constants
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

//extended colors
const ClrPurple = 0xAA00FF;
const ClrDkPurple = 0x5500AA;//0xAA00FF;

//--- FONTS - 0=smallest, FN?=number
//JBL - justify baseline
//JT - justify top of letters, subtracting out white space
//JB - justify bottom
//JN - none - don't show

enum {F0, F1, F2, F3, F4,FN0, FN1, FN2, FN3, FX1, FX2, FCnt}
enum {JR, JC, JL, JVC=4, JCC=5, JCORE=7, JBL=8, JT=16, JT_C=17, JB=32, JL_BL=10, JR_BL=8, JC_BL=9, JCL=6, JN=-1} //justify

//--- FONT Metrics - we add in a level of indirection since stock fonts are indexes,
//                   custom fonts are objects.
var Fnt = [];  //list of font objects - mapping from fnt index to font
var FntName =["F0 XTINY","F1 TINY","F2 SMALL","F3 MEDIUM","F4 LARGE","FN0 #MILD","FN1 #MEDIUM","FN2 #HOT","FN3 #THAIHOT"];
var FntHeight; //[FCount] - getFontHeight
var FntAscent; //[FCount] - base line of font to top of box (last pixel in zero)
//var FntDescent;//[FCount] - base line to bottom
var FntCYOff;  //dist from top of font box to top of characters

var cxScreen = Sys.getDeviceSettings().screenWidth;
var cyScreen = Sys.getDeviceSettings().screenHeight;
var xCenter = cxScreen / 2;
var yCenter = cyScreen / 2;

//-----------------------------------------------------
function initDrawingHelper()
{
    //initialize some font helpers
    //CY0 - these are actually counted values for the height of zeros's
    //var rgrgFntCY =
    //[
    //    [11,11,11,14,19,20,32,40,71], //FR630
    //    [10,10,11,14,15,19,31,35,47] //VAHR
    //];
    FntHeight = new [0];
    FntAscent = new [0];
    //FntDescent = new [0];
    FntCYOff = new [0];
    //add in the stock fonts
    //logMsg.logMsg("index\theight\tascent\tdescent");
    for (var i = 0; i < FX1; ++i)
    {
        addFont(i,null);
    }

    //MEMORYLIMIT
    //if (dev==DEV_VAHR)
    //{
    //    addFont(Ui.loadResource(Rez.Fonts.id_font_BigNumThin),"FX1"); //FX1
    //    addFont(Ui.loadResource(Rez.Fonts.id_font_BigNumThick),"FX2"); //FX2
    //}
}
//-----------------------------------------------------
function addFont(f,name)
{
    var i = Fnt.size();
    Fnt.add(f);
    if (name != null) {FntName.add(name);}
    FntHeight.add(Gfx.getFontHeight(f));
    FntAscent.add(Gfx.getFontAscent(f));//+1;
    //FntDescent.add(Gfx.getFontDescent(f)); //also approx margin top above pixels
    FntCYOff.add(Gfx.getFontDescent(f));  //not exact but close
    //logMsg.logMsg(
    //  Lang.format("$1$\t$2$\t$3$\t$4$",
    //  [i,FntHeight[i], FntAscent[i], FntCYOff[i]]));
} 

//---------------------------------------------------------
//---------------------------------------------------------
class Rect
{
    var x0, x1, y0, y1; //bounding box
    //---------------------------------
    function initialize(x0_, y0_, x1_, y1_)
    {
        x0 = x0_;
        y0 = y0_;
        x1 = x1_;
        y1 = y1_;
    }
    //---------------------------------
    function isEmpty() {return((x0 == x1) || (y0 == y1));}
    function contains(x,y,c) {return((x >= x0-c) && (x <= x1+c) && (y >= y0-c) && (y <= y1+c));}
    function width() {return(x1 - x0);}
    function height() {return(y1 - y0);}
    function xCenter() {return((x1+x0)/2);}
    function yCenter() {return((y1+y0)/2);}
    //---------------------------------
    function print(str)
    {
        Sys.println(Lang.format("$1$: $2$, $3$, $4$, $5$",[str,x0,y0,x1,y1]));
    }
    //---------------------------------
    function draw(dc,clr)
    {
        dc.setColor(clr,clr);
        dc.drawRectangle(x0,y0,x1-x0,y1-y0);
    }
    //---------------------------------
    function fill(dc,clr)
    {
        dc.setColor(clr,clr);
        dc.fillRectangle(x0,y0,x1-x0,y1-y0);
    }
    //---------------------------------
    function wellOrder()
    {
        if (x0 > x1) {var x=x0; x0=x1; x1=x;}
        if (y0 > y1) {var y=y0; y0=y1; y1=y;}
    }
}

//---------------------------------------------------------
//---------------------------------------------------------
var DrawTextExtra = 2; //extra inter line spacing

function adjustY(y,fnt,just)
{
    if((just & JT) == JT) {y = y;}// - FntCYOff[fnt];}
    else if((just & JBL) == JBL) {y = y - FntAscent[fnt];}
    else if((just & JB) == JB) {y = y - FntHeight[fnt];}
    else {y = y - FntCYOff[fnt];}
    return(y);
}
//---------------------------------
enum {DTR_X, DTR_Y, DTR_FNT, DTR_JUST, DTR_CLR}
function drawTextRg(dc, rgtxt,rgclr,rgf, clrFore, clrBack)
{
    for (var i = 0; i < rgtxt.size(); ++i)
    {
        if ((rgf[i][DTR_JUST] != JN) && (rgtxt[i] != null))
        {
            var clr=null;
            if (rgf[i].size() > DTR_CLR){clr = rgf[i][DTR_CLR];}

            if (clr == null) {clr = rgclr[i];}
            if (clr == null) {clr = clrFore;}
            dc.setColor(clr,clrBack);

            var y = adjustY(rgf[i][DTR_Y],rgf[i][DTR_FNT],rgf[i][DTR_JUST]);
            dc.drawText( //x,y,fnt,str,just & JCORE);
               rgf[i][DTR_X],y,Fnt[rgf[i][DTR_FNT]],rgtxt[i],rgf[i][DTR_JUST] & JCORE);
        }
    }
}

//---------------------------------
function drawTextX(dc, x,y,fnt,str,just,clr)
{
    dc.setColor(clr, Gfx.COLOR_TRANSPARENT);
    y = adjustY(y,fnt,just);
    dc.drawText(x,y,Fnt[fnt],str,just & JCORE);
    return(dc.getTextWidthInPixels(str+"", Fnt[fnt]));
}
//---------------------------------
function drawTextY(dc, x,y,fnt,str,just,clr)
{
    //Sys.println("drawTextX(" + x + "," + y+","+str+")");
    dc.setColor(clr, Gfx.COLOR_TRANSPARENT);
    y = adjustY(y,fnt,just);
    dc.drawText(x,y,Fnt[fnt],str,just & JCORE); //first pixels close to y
    return(FntAscent[fnt] + DrawTextExtra);
}

//---------------------------------
function drawLine(dc,x0,y0,x1,y1,clr) {dc.setColor(clr,clr);dc.drawLine(x0,y0,x1,y1);}
function drawRect(dc,x,y,cx,cy,clr) {dc.setColor(clr,clr);dc.drawRectangle(x,y,cx,cy);}
function fillRect(dc,x,y,cx,cy,clr) {dc.setColor(clr,clr);dc.fillRectangle(x,y,cx,cy);}
function drawCircle(dc,x,y,r,clr) {dc.setColor(clr,clr);dc.drawCircle(x,y,r);}
function fillCircle(dc,x,y,r,clr) {dc.setColor(clr,clr);dc.fillCircle(x,y,r);}

//---------------------------------
function drawPolygon(dc,rg)
{
    for (var i = 1; i < rg.size(); ++i)
    {
        dc.drawLine(rg[i-1][0],rg[i-1][1],rg[i][0],rg[i][1]);
    }
}
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
var rgptPlus=[0,1,1,1,1,0,2,0,2,1,3,1,3,2,2,2,2,3,1,3,1,2,0,2,0,1];
var rgptMinus = [0,1,3,1,3,2,0,2,0,1];

function drawPolylineAlt(dc,rg,xOff,yOff,scale,clr,penWidth)
{
    dc.setColor(clr,clr);
    dc.setPenWidth(penWidth);

    var x0 = rg[0] * scale + xOff;
    var y0 = rg[1] * scale + yOff;
    for (var i = 2; i < rg.size(); i+=2)
    {
        var x1 = rg[i] * scale + xOff;
        var y1 = rg[i+1] * scale + yOff;
        dc.drawLine(x0,y0,x1,y1);
        x0 = x1;
        y0 = y1;
    }
}

//---------------------------------
//draw a small circle on the perimeter of the watch in the direction of hdg
//hdg - 0=N, 90=Pi/2=E, 180=Pi=S, -90=270=-Pi/2=W
function drawHdgCirc(dc,hdg,r,clr)
{
    if (hdg != null)
    {
//        var screenShape = Sys.getDeviceSettings().screenShape;
//        if ((screenShape == Sys.SCREEN_SHAPE_SEMI_ROUND) ||
//            (screenShape == Sys.SCREEN_SHAPE_ROUND))
//        {
            var x = xCenter + Math.cos(hdg+Pi/2) * xCenter;   //reverse angles CW vs CCW
            var y = yCenter - (Math.sin(hdg+Pi/2) * xCenter); //inverted drawing coords

            if (y < 0) {y=0;}
            if (y > cyScreen) {y=cyScreen;}
            //Sys.println(Lang.format("$1$,$2$,$3$,$4$,$5$",[hdg,x,y,Math.cos(hdg),Math.sin(hdg)]));
            dc.setColor(clr,clr);
            dc.fillCircle(x,y,r);
//        }
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

    dc.setColor(clrBg,clrBg);
    dc.setPenWidth(1);
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

//---------------------------------
function drawPauseScreen(dc)
{
    dc.setPenWidth(6);
    drawCircle(dc,xCenter,yCenter,xCenter-2,ClrRed);
    drawRect(dc,xCenter-25,yCenter-25,50,50,ClrRed);
}    
