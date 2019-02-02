using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

var iLvl = 0;


function popAll()
{
    while (iLvl > 0)
    {
        popView1();
    }
}
function popView1()
{
    Ui.popView(Ui.SLIDE_IMMEDIATE);
    --iLvl;
    Sys.println("PopView: " + iLvl);
}

function pushView1(view,del)
{
   iLvl++;
   Sys.println("PushView: " + iLvl);
   Ui.pushView(view,del , Ui.SLIDE_UP);
}
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class TestPopViewDelegate extends Ui.BehaviorDelegate 
{

    function initialize() 
    {
        BehaviorDelegate.initialize();
    }

    function onNextPage()
    {
        popView1();
        return(true);
    }
    function onPreviousPage() 
    {
        pushView1(new TestPopViewView(), new TestPopViewDelegate());
        return true;
    }
    
    function onSelect()
    {
        showMenu();
    }
    
    function onBack()
    {
        popAll();
        return(true);
    }
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class TestPopViewView extends Ui.View 
{
    var iLvlCur;
    function initialize() 
    {
        iLvlCur = iLvl+1;
        View.initialize();
    }

    // Update the view
    function onUpdate(dc) 
    {
        var fnt = Gfx.FONT_LARGE;
        var cyFnt = dc.getFontHeight(fnt);
        var x = dc.getWidth()/2;
        var y = cyFnt;
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();
        
        dc.drawText(x, y, fnt, "iLvlCur =  " + iLvlCur, Gfx.TEXT_JUSTIFY_CENTER);
        y += cyFnt;
        dc.drawText(x, y, fnt, "iLvl =  " + iLvl, Gfx.TEXT_JUSTIFY_CENTER);
    }
}
