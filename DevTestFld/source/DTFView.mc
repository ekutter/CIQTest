using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class DevTestFldView extends Ui.DataField 
{
	var cLayout = 0;
	var cCompute = 0;
	var cUpdate = 0;
	//-------------------------------------------
    function initialize() 
    {
        DataField.initialize();
    }

	//-------------------------------------------
    function onLayout(dc) 
    {
    	cLayout++;
    }
    
	//-------------------------------------------
	function strObscure()
	{
		var str = "";
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags & OBSCURE_TOP) {str += "T";}
        if (obscurityFlags & OBSCURE_LEFT) {str += "L";}
        if (obscurityFlags & OBSCURE_BOTTOM) {str += "B";}
        if (obscurityFlags & OBSCURE_RIGHT) {str += "R";}
        return(str);
    }

	//-------------------------------------------
    function compute(info) 
    {
    	cCompute++;
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate)
        {
        }
    }

	//-------------------------------------------
    function onUpdate(dc) 
    {
    	var cx = dc.getWidth();
    	var cy = dc.getHeight();
    	cUpdate++;
    	dc.setColor(ClrWhite, ClrWhite);
    	dc.clear();
    	
    	dc.setColor(ClrRed,ClrTrans);
    	dc.setPenWidth(4);
    	dc.drawRectangle(0,0,cx,cy);
    	
    	dc.setColor(ClrBlack,ClrTrans);
    	var y = cy / 2 - dc.getFontHeight(F2);
		var str = Lang.format("$1$,$2$,$3$",[cLayout, cCompute,cUpdate]);  
		dc.drawText(cx/2,y,F2,str, JC);
		   
		y += dc.getFontHeight(F2); 	
		str = Lang.format("[$1$,$2$] $3$ ",[cx,cy,strObscure()]);  
		dc.drawText(cx/2,y,F2,str, JC);
    	
    }

}
