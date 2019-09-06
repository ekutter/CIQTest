using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
var rgmsg = ["Press a button","or tap the screen","to see button","and touch events","","", ""];
var cMsg = 0;

//-----------------------------------------------------
function addMsg(str)
{
    cMsg = (cMsg + 1) % 100;
    str = cMsg + ": " + str;
    Sys.println(str);
    rgmsg.add(str);
    if (rgmsg.size() > 10)
    {
        rgmsg.remove(rgmsg[0]);
    }
    Ui.requestUpdate();
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class TestAntConnectionView extends Ui.View 
{

    //-----------------------------------------------------
    function initialize() 
    {
        View.initialize();
    }

    //-----------------------------------------------------
    function onUpdate(dc) 
    {
        dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_BLACK);
        dc.clear();
        
        var fnt = Gfx.FONT_MEDIUM;
        fnt = Gfx.FONT_SMALL;
        var cyLine = dc.getFontHeight(fnt);
        var y = dc.getHeight() - cyLine - cyLine;
        
        for (var i = rgmsg.size()-1; i >= 0; i--)
        {
            dc.drawText(dc.getWidth()/2, y, fnt, rgmsg[i], Gfx.TEXT_JUSTIFY_CENTER);
            y -= cyLine;
        }
    }

}
