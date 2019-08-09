using Toybox.WatchUi;
using Toybox.Graphics as Gfx;

class TestMapFldView extends WatchUi.DataField {

    hidden var mValue;

    function initialize() {
        DataField.initialize();
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate){
            if(info.currentHeartRate != null){
                mValue = info.currentHeartRate;
            } else {
                mValue = 0.0f;
            }
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    var i = 0;
    function onUpdate(dc) 
    {
        i += 1;
        //dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_TRANSPARENT);
        if (true) 
        {
            //Fill the whole cell
            dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_YELLOW);
            dc.clear();
            dc.drawText(dc.getWidth()/2,dc.getHeight()/2,Gfx.FONT_LARGE,dc.getWidth() + "x" + dc.getHeight(),
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        }
        else
        {
            //transparent test
            dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_BLUE);
            dc.setPenWidth(2);
            dc.drawRectangle(0,0,dc.getWidth(),dc.getHeight());
            
            dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_YELLOW);
            dc.drawText(dc.getWidth()/2,dc.getHeight()/2,Gfx.FONT_LARGE,i,Gfx.TEXT_JUSTIFY_CENTER);
            dc.drawText(dc.getWidth()/2,0,Gfx.FONT_LARGE,dc.getWidth() + "x" + dc.getHeight(),Gfx.TEXT_JUSTIFY_CENTER);
        }
    }

}
