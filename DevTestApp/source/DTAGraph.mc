using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Math as Math;

//---------------------------------------------------------
//---------------------------------------------------------
class GraphSer
{
    var clr = ClrDkGreen;
    var rg;
    var iCur;   //index into last
    var cDP;    //valid DP in use, might be less than rg.size()
    var min;    //to display
    var max;    //to display
    
    var fWrap = true;
    var fAutoMinMax = true;
    
    //---------------------------------
    function initialize(clr_, min_, max_, c)
    {
        rg = new [c];
        min = min_;
        max = max_;
        fAutoMinMax = (min == IntMax);
        clr = clr_;
        reset();
    }
    //---------------------------------
    function reset()
    {
        iCur = -1;
        cDP = 0;
        if (fAutoMinMax)
        {
	        min = IntMax;
	        max = IntMin;
	    }
    }
    
    //---------------------------------
    function add(v)
    {
        iCur++;
        if (iCur == rg.size())
        {
            iCur = 0;
        }
        else if (cDP < rg.size())
        {
            cDP++;
        }
        rg[iCur] = v;
        
        if (fAutoMinMax)
        {
	        if (v > max) {max = v;}
	        if (v < min) {min = v;}
	    }
    }    
}
//---------------------------------------------------------
//---------------------------------------------------------
class Graph
{
    var rgser = new [0];
    
    //---------------------------------
    function initialize()
    {
        reset();
    }
    //---------------------------------
    function reset()
    {   
        for (var i = 0; i < rgser.size(); ++i) {rgser[i].reset();}
    }
    //---------------------------------
    function drawGraph(dc, rc)
    {
        dc.setPenWidth(2);
        rc.draw(dc,ClrLtGray);
        drawLine(dc,rc.x0,rc.yCenter(),rc.x1,rc.yCenter(),ClrLtGray);
        dc.setPenWidth(1);

        for (var i = 0; i < rgser.size(); ++i)
        {
            var ser = rgser[i];
            if (ser.cDP > 1)
            {
		        var yMin = ser.min;
		        var yMax = ser.max;
		
		        //fillRect(dc,rc.x0+18,rc.y0-1,67,2,ClrFG);
		        //fillRect(dc,rc.x0+18,rc.y1-2,67,2,ClrFG);
		        
		        if ((ser.cDP > 1) && (yMax != yMin))
		        {
		            //minus 2 to deal with the line width
		            var yScale = (rc.height().toFloat()-2) / (yMax-yMin);//hr to pixel
		            var xScale = (rc.width().toFloat()-2) / (ser.fWrap ? (ser.rg.size()-1) : (ser.cDP-1)); //this is actually a constant
		            dc.setColor(ser.clr,ClrTrans);
		            dc.setPenWidth(3);
		            
		            var ValND = null;
		            var y1;  //put this outside the loop so we can draw the full H line at the last location
		            var iFld = 0;
		            var val0 = ValND; //seed it with zero.  Will skip drawing the first item
		            var cDraw = 0;
		            //Sys.println(ser.cDP + ", " + ser.rg);
		            for (var i = 0; i < ser.cDP; ++i)
		            {
		                var iVal = ser.fWrap ? ((ser.iCur - ser.cDP + i + ser.rg.size()) % ser.rg.size()) : (i);
		                var val1 = ser.rg[iVal];
		                if ((val0 != ValND) && (val1 != ValND))
		                { 
		                    //Sys.println(i + ", " + val0 + ", " + yScale + ", " + val1);
		                    var y0 = (val0-yMin) * yScale;
		                    var x0 = (i-1)*xScale;
		            
		                    y1 = (val1-yMin) * yScale;
		                    var x1 = i * xScale;
		                    
		                    //Sys.println(Lang.format("graph: iHR=$1$, x0=$2$, x1=$3$",[iHR,x0,x1]));
		                    dc.drawLine(rc.x0+x0,rc.y1-y0-2,rc.x0+x1,rc.y1-y1-2);
		                    ++cDraw;
		                }
		                val0 = val1;
		            }
		            
	            }

	        } 
	    }       
        //draw a line at the current elevation
//        dc.setPenWidth(2);
//        if (y1 != null) {drawLine(dc,rc.x0,rc.y1-y1-2,rc.x1,rc.y1-y1-2,ClrRed);}
    }
}