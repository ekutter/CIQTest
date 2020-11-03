//
// Copyright 2016-2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.Application.Storage;
using Toybox.System as Sys;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class WF1SettingsMenuItem extends Ui.MenuItem 
{

    private var mId;

    //-----------------------------------------------------
    function initialize(id) 
    {
        MenuItem.initialize();

        mId = id;
    }
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class SettingsMenu extends Ui.Menu2 
{

    //-----------------------------------------------------
    function initialize() 
    {
        Sys.println("WF1SettingsMenu.init");
        Menu2.initialize(null);
        Menu2.setTitle("Settings");
    }
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class SettingsMenuDelegate extends Ui.Menu2InputDelegate 
{

    //-----------------------------------------------------
    function initialize() 
    {
        Sys.println("WF1SettingsMenuDelegate.init");
        Menu2InputDelegate.initialize();
    }

    //-----------------------------------------------------
    function onBack()
    {
        Sys.println("OnBack - popView");
        Ui.popView(Ui.SLIDE_IMMEDIATE);
        Sys.println("returning");
        return(false);
    }

    //-----------------------------------------------------
    function onSelect(menuItem) 
    {
        var id = menuItem.getId();
        var val = menuItem.isEnabled();
        Sys.println("SettingsMenuDelegate.OnSelect: " + menuItem + ", id=" + id + ", val=" + val);
        
        switch(id)
        {
            case FDbgMode:
                fDbgMode = menuItem.isEnabled();
                Storage.setValue(id,fDbgMode);
                break;
        }
    }
}

 