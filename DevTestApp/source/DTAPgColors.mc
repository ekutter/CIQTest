using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

//---------------------------------------------------------
//---------------------------------------------------------
class PgColorsDelegate extends Ui.BehaviorDelegate
{
    //---------------------------------
    function onNextPage() {state.setPg(1);}     
    function onPreviousPage() {state.setPg(-1);} 
    function onBack() {return(true);}
}

//---------------------------------------------------------
class PgColorsView extends Ui.View
{
    //---------------------------------
    function onUpdate(dc)
    {
        dc.setColor(ClrBlack,ClrBlack);
        dc.clear();

        var y = 4;
        fillRect(dc,0,0,cxScreen,FntAscent[F4],ClrYellow);
        y += drawTextY(dc,xCenter,y,F4,"Colors",JC,ClrWhite);
        
        var rgclr = [ClrBlue, 0x0088ff, 0x66ff, 0x55ff, 0x44ff, 0x22ff, 0x00ff];

        var cyRow = Gfx.getFontHeight(F3)+2;
        
        for (var i = 0; i < rgclr.size(); ++i)
        { 
            dc.setColor(rgclr[i],rgclr[i]);
            dc.fillRectangle(0,y,cxScreen,cyRow);
            dc.setColor(ClrWhite,ClrTrans);
            dc.drawText(xCenter,y,F3,"0x"+rgclr[i].format("%06X"),JC);
            y += cyRow+2;
        }

    }
}