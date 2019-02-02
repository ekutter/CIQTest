using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
function showMenu()
{
    //Sys.println("onMenu");
    var menu = new Ui.Menu2({:title=>"Main"});
    menu.addItem(new Ui.MenuItem("ExitAll", null,"exitAll",null));
    menu.addItem(new Ui.MenuItem("Settings", null,"settingsMnu",null));
    menu.addItem(new Ui.MenuItem("Diagnostics", null,"diagnostics",null));
    pushView1(menu, new TrackerMenu2Delegate());
    return(true);
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class TrackerMenu2Delegate extends Ui.Menu2InputDelegate 
{
    //---------------------------------
    function initialize() 
    {
        Menu2InputDelegate.initialize();
    }

    //---------------------------------
    function onSelect(item) 
    {
        switch (item.getId())
        {
        case "exitAll":
            popAll();   
            break;
        default:
            break;
        }
    }

    //---------------------------------
    
    
    //---------------------------------
    function onBack() 
    {
        popView1();
    }
}
