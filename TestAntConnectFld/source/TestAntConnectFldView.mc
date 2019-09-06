using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class TestAntConnectFldView extends Ui.DataField 
{

    //-----------------------------------------------------
    function initialize() 
    {
        DataField.initialize();
    }

    //-----------------------------------------------------
    function compute(info) 
    {
        if (((Sys.getTimer() / 1000) % 10) == 0)
        {
            if (sensor.searching)
            {
                addMsg("searching...");
            }
            else
            {
                addMsg("tic cMsg=" + sensor.cMsg);
            }
        }
    }

    //-----------------------------------------------------
    function onUpdate(dc) 
    {
        dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_BLACK);
        dc.clear();
        displayMsg(dc);
    }
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
var rgmsg = [];
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
    //Ui.requestUpdate();
}

//-----------------------------------------------------
// display the messages from rgmsg - colors must already be set.
function displayMsg(dc)
{
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
