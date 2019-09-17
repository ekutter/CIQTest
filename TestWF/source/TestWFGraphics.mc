using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Activity as Act;

var gxGlobal; //global graphcis
public class Gx
{
    var dc; //this is set in getGx() and then used throughout
    
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
    enum {F0, F1, F2, F3, F4,FN0, FN1, FN2, FN3, FX1, FX2}

    //--- FONTS - 0=smallest, FN?=number
    // justify horizontal/vertical
    //  rgFntAdjust[yAlign] - [<0>],[<T>],[<M>],[<_=bl>],[<b>]
    //  yAlign=0; yPos = y-rgFntAdjust[j>>3][iFnt];
    //
    //    
    // originals - enum {JR, JC, JL, JVC=4, JCC=5, JCORE=7, JBL=8, JT=16, JB=32, JL_BL=10, JR_BL=8, JC_BL=9, JCL=6, JTR=16, JTL=18, JN=-1} //justify
    enum {
        JR0=0x00, JC0=0x01, JL0=0x02,  //0x00 - top of bounding box 
        JRT=0x10, JCT=0x11, JLT=0x12,  //0x04 - top of glypha 
        JRM=0x20, JCM=0x21, JLM=0x22,  //0x08 - vertically centered 
        JR_=0x30, JC_=0x31, JL_=0x32,  //0x10 - base line 
        JRB=0x40, JCB=0x41, JLB=0x42,  //0x20 - bottom of bounding box
        JH=0x0f, JV=0xf0,  //groups
        JV0=0x00, JVT=0x10, JVM=0x20, JV_=0x30, JVB=0x40, //vertical values
        JN=0xff} //none - don't draw the text  
    
    //--- FONT Metrics - we add in a level of indirection since stock fonts are indexes,
    //                   custom fonts are objects.
    var Fnt = [];   //list of font objects - mapping from fnt index to font
    var FntName =["F0","F1","F2","F3","F4","FN0","FN1","FN2","FN3"];
    
    const cxScreen = 240;
    const cyScreen = 240;
    const xCenter = 120;
    const yCenter = 120;
    
    static var cxScreenPx = Sys.getDeviceSettings().screenWidth;
    static var cyScreenPx = Sys.getDeviceSettings().screenHeight;
    
    var xScale = Sys.getDeviceSettings().screenWidth * 1.0 / cxScreen;
    var yScale = Sys.getDeviceSettings().screenHeight * 1.0 / cyScreen;
    //var xScale = cxScreenPx * 1.0 / cxScreen;
    //var yScale = cyScreenPx * 1.0 / cyScreen;

    var FntCYLine=[]; //height to move from one line to the next in 240 coordinates 
    
    //vertical offset arrays for each font
    var FntOff0 = []; 
    var FntOffT = []; 
    var FntOffM = []; 
    var FntOff_ = []; 
    var FntOffB = []; 
    var rgFntOff = [FntOff0, FntOffT, FntOffM, FntOff_, FntOffB]; //array of the above

    //-----------------------------------------------------
    function setDC(dcIn) {dc=dcIn;}
    function clear(clr) {dc.setColor(clr,clr); dc.clear();}
    function initialize()
    {
        //Sys.println(Lang.format("Gx.init screen=[$1$,$2$], Scale=[$3$,$4$]",[cxScreen,cyScreen,xScale,yScale]));
        //add in the stock fonts
        //Sys.println("Fonts: 0, T, M, BL, B=ht, cyLine");
        
        for (var i = 0; i <= F4; ++i)
        {
            addFont(i,null);
        }

        //replace the number fonts
        //if (Sys.getDeviceSettings().partNumber == "006-B3290-00")
        //probably do this on wide font devices
        var pn = Sys.getDeviceSettings().partNumber;

//      switch (pn)
//      {
//      case "": //"006-B3290-00": //F6
//          Sys.println("numfonts: downsized");
//          //basically down size by one font as the num fonts on the F6 are huge
//          addFont(F4,null); //
//          addFont(FN0,null); //
//          addFont(FN1,null); //
//          addFont(FN2,null); //
//          break;
//      case "006-B3290-00": //F6
//      case "006-B3077-00": //245
//      case "006-B3288-00": //F6s
//      case "006-B3113-00": //F6s
//          Sys.println("numfonts: custom");
//          addFont(Ui.loadResource(Rez.Fonts.id_font_Ex0),null);
//          addFont(Ui.loadResource(Rez.Fonts.id_font_Ex1),null);
//          addFont(Ui.loadResource(Rez.Fonts.id_font_Ex2),null);
//          addFont(Ui.loadResource(Rez.Fonts.id_font_Ex3),null);
//          break;
//      default:
            //Sys.println("numfonts: normal");
            addFont(FN0,null); //
            addFont(FN1,null); //
            addFont(FN2,null); //
            addFont(FN3,null); //
//          break;
//      }
//  
//      addFont(Ui.loadResource(Rez.Fonts.id_font_BigNumThin),"FX1"); //FX1
//      addFont(Ui.loadResource(Rez.Fonts.id_font_BigNumThick),"FX2"); //FX2
        
        //if ($ has :fixFonts) {fixFonts();}
    }
    //-----------------------------------------------------
    function addFont(f,name)
    {
        var i = Fnt.size();
        Fnt.add(f);
        if (name != null) {FntName.add(name);}
        
        var height = Gfx.getFontHeight(f);
        var asc = Gfx.getFontAscent(f);
        var desc = Gfx.getFontDescent(f); 
         
        FntOff0.add(0);                      //it's the top - always the top
        FntOffT.add(desc);  //estimated white space at top
        FntOffM.add(height / 2);             //not sure it's this simple
        FntOff_.add(asc);   // is this actually the same as ascent?
        FntOffB.add(height);
        
        FntCYLine.add(((asc-desc)*1.1+2)/yScale); //no idea what to do here - should scale with the font probably
        
//      Sys.println(
//        Lang.format("Font[$1$] $2$: 0,$3$,$4$,$5$,$6$,$7$",
//        [i,FntName[i],FntOffT[i],FntOffM[i],FntOff_[i],FntOffB[i],FntCYLine[i]]));
    }
    
    //---------------------------------------------------------
    function getTextWidth(dc,str,fnt)
    {
        var cx = dc.getTextWidthInPixels(str,fnt);
        return(cx / xScale);        
    }
    
    function getTextDimensions(dc,str,fnt)
    {
        var cxcy = dc.getTextDimensions(str,fnt);
        cxcy[0] /= xScale;
        cxcy[1] /= yScale;
    }
    
    //---------------------------------------------------------
    private function adjustY(y,iFnt,just)
    {
        //y has already been scaled to the current screen
        var jy = just >> 4; //y adjust index
        var yOff = rgFntOff[jy][iFnt];
        return(y-yOff);
    }
    //---------------------------------
    //multi text draw - parameters are in a one dim array of the following structure
    //color priority - rgtxt[clr], rgclr, clrFore
    enum {DTR_X, DTR_Y, DTR_FNT, DTR_JUST, DTR_CLR}
    function drawTextRg(rgtxt,rgclr,rgf, clrFore, clrBack)
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
    
                var y = adjustY(rgf[i][DTR_Y],rgf[i][DTR_FNT],rgf[i][DTR_JUST]); //adjust y for default alignment
                dc.drawText( //x,y,fnt,str,just & JCORE);
                   rgf[i][DTR_X]*xScale,y*yScale,   // x,y
                   Fnt[rgf[i][DTR_FNT]],            // font
                   rgtxt[i],                        // text
                   rgf[i][DTR_JUST] & JH);          // horizontal justification
            }
        }
    }
    
    //---------------------------------
    function drawTextX(x,y,fnt,str,just,clr)
    {
        x *= xScale;
        y *= yScale;
        dc.setColor(clr, Gfx.COLOR_TRANSPARENT);
        y = adjustY(y,fnt,just);
        dc.drawText(x,y,Fnt[fnt],str,just & JH);
        return((dc.getTextWidthInPixels(str+"", Fnt[fnt])) / xScale);
    }
    
    //---------------------------------
    function drawTextY(x, y,iFnt,str,just,clr)
    {
        x *= xScale; 
        y *= yScale;
        //Sys.println("drawTextX(" + x + "," + y+","+str+")");
        dc.setColor(clr, Gfx.COLOR_TRANSPARENT);
        y = adjustY(y,iFnt,just);
        dc.drawText(x,y,Fnt[iFnt],str,just & JH); //first pixels close to y
        return(FntCYLine[iFnt]); 
    }

    //---------------------------------
    function drawTextBk(x, y,iFnt,str,just,clrFg,clrBg)
    {
        x *= xScale; 
        y *= yScale;
        //Sys.println("drawTextX(" + x + "," + y+","+str+")");
        dc.setColor(clrFg, clrBg);
        y = adjustY(y,iFnt,just);
        //var dim = dc.getTextDimensions(str,Fnt[iFnt]);
        //dc.setClip(x, y, dim[0],dim[1]);
        dc.drawText(x,y,Fnt[iFnt],str,just & JH); //first pixels close to y
    }
    
    //---------------------------------
    function setClip(x,y,cx,cy) 
    {
        //Sys.println(dc);
        dc.setClip(x*xScale,y*yScale,cx*xScale,cy*yScale);
    }
    function setPenWidth(n) {dc.setPenWidth(n);}
    function drawLine(x0,y0,x1,y1,clr) {dc.setColor(clr,clr);dc.drawLine(x0*xScale,y0*yScale,x1*xScale,y1*yScale);}
    function drawRect(x,y,cx,cy,clr) {dc.setColor(clr,clr);dc.drawRectangle(x*xScale,y*yScale,cx*xScale,cy*yScale);}
    function fillRect(x,y,cx,cy,clr) {dc.setColor(clr,clr);dc.fillRectangle(x*xScale,y*yScale,cx*xScale,cy*yScale);}
    function drawCircle(x,y,r,clr) {dc.setColor(clr,clr);dc.drawCircle(x*xScale,y*yScale,r*xScale);} //r*xScale may not be right
    function fillCircle(x,y,r,clr) {dc.setColor(clr,clr);dc.fillCircle(x*xScale,y*yScale,r*yScale);}
    function drawBitmap(x,y,img) {dc.drawBitmap(x*xScale, y*yScale, img);}
    function fillPolygon(rgpt,clr)
    {
        var rgpt2 = new [rgpt.size()];
        for (var i = 0; i < rgpt.size(); ++i)
        {
            var pt = new [2];
            rgpt2[i] = pt;
            pt[0] = rgpt[i][0]*xScale;
            pt[1] = rgpt[i][1]*yScale;
        } 
        dc.setColor(clr,clr);
        dc.fillPolygon(rgpt2);
    }
    
    //---------------------------------
    function drawPolygon(rg)
    {
        for (var i = 1; i < rg.size(); ++i)
        {
            dc.drawLine(rg[i-1][0]*xScale,rg[i-1][1]*yScale,rg[i][0]*xScale,rg[i][1]*yScale);
        }
    }
    //---------------------------------
    function drawPolyline(rgx,rgy,cPt,clr,penWidth)
    {
        dc.setColor(clr,clr);
        dc.setPenWidth(penWidth);
        var x0 = rgx[0]*xScale;
        var y0 = rgy[0]*yScale;
        for (var i = 1; i < cPt; ++i)
        {
            var x1 = rgx[i]*xScale;
            var y1 = rgy[i]*yScale;
            dc.drawLine(x0,y0,x1,y1);
            x0 = x1;
            y0 = y1;
        }
    }
    //---------------------------------
    function drawPolyline2(rgpt,clr,penWidth)
    {
        var cPt = rgpt.size();
        
        dc.setColor(clr,clr);
        dc.setPenWidth(penWidth);
        var x0 = rgpt[0][0]*xScale;
        var y0 = rgpt[0][1]*yScale;
        for (var i = 1; i < cPt; ++i)
        {
            var x1 = rgpt[i][0]*xScale;
            var y1 = rgpt[i][1]*yScale;
            dc.drawLine(x0,y0,x1,y1);
            x0 = x1;
            y0 = y1;
        }
    }
    //---------------------------------
    static var rgptPlus=[0,1,1,1,1,0,2,0,2,1,3,1,3,2,2,2,2,3,1,3,1,2,0,2,0,1];
    static var rgptMinus = [0,1,3,1,3,2,0,2,0,1];
    static var rgDnArrow = [-2,0,2,0,0,3,-2,0];
    static var rgUpArrow = [-2,0,2,0,0,-3,-2,0];
    
    
    function drawPolylineAlt(rg,xOff,yOff,scale,clr,penWidth)
    {
        setPenWidth(penWidth);
    
        var x0 = (rg[0] * scale + xOff)*xScale;
        var y0 = (rg[1] * scale + yOff)*yScale;
        for (var i = 2; i < rg.size(); i+=2)
        {
            var x1 = (rg[i] * scale + xOff)*xScale;
            var y1 = (rg[i+1] * scale + yOff)*yScale;
            drawLine(x0,y0,x1,y1,clr);
            x0 = x1;
            y0 = y1;
        }
    }
}

