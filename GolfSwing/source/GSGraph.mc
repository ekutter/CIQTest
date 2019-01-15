using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Math as Math;

//---------------------------------------------------------
//---------------------------------------------------------
class GraphSer
{
	var strName;		
    var clr = ClrDkGreen;
    var rg;
    var iCur;   //index into last
    var cDP;    //valid DP in use, might be less than rg.size()
    var min;    //to display
    var max;    //to display
    
    var fWrap = true;
    var fAutoMinMax = true;
    
    //---------------------------------
    function initialize(nm_, clr_, min_, max_, c)
    {
    	strName = nm_;
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
    //---------------------------------
    function get(i)
    {
        var iVal = fWrap ? ((iCur - cDP + i + rg.size()) % rg.size()) : (i);
        return(rg[iVal]);    
    }
    //---------------------------------
    const CBase = 26+26+10; //A-Za-z0-9
    const StrCharCompress = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    const MaxVal = CBase * CBase; // maximum value that can be compressed in 2 digits
    function iToStr(i)
    {   
        var a = i / CBase;
        var b = i % CBase;
        return(StrCharCompress.substring(a,a+1)+StrCharCompress.substring(b,b+1));
    }
    //---------------------------------
    // uint16: count
    // uint16: min
    // uint16: max
    // base(62) compressed string
    function toCompressedStr()
    {
        var min1 = IntMax;          // actual min value
        var max1 = IntMin;          // actual max value
        var sz = rg.size();         // size of array to transmit

        //first figure out the range
        for (var iDP = 0; iDP < sz; ++iDP)
        {
            var v = rg[iDP];
            if (v != null)
            {
		        if (v > max1) {max1 = v;}
		        if (v < min1) {min1 = v;}
            }
        }
        var valRange = max1-min1+1;
        var strRet = strName + cDP.format("%04X") + min1.format("%08X").substring(4,8) + max1.format("%08X").substring(4,8);
        var iDP = fWrap ? ((iCur - cDP + sz) % sz) : 0; //find the starting point
        
        //Sys.println(Lang.format("sz=$1$ range=$2$, min=$3$, max=$4$",[sz,valRange,min1,max1]));
        //Sys.println(rg);
        
        for (var i = 0; i < cDP; ++i)
        {
            iDP = (iDP + 1) % sz;
            var v = rg[iDP];
            if (v == null) {v = min1;}
            v = v - min1; //make sure it's >= 0
            var s = iToStr(v * MaxVal / valRange);
            strRet += s;
        }
        
        //Sys.println("series: " + strRet);
        return(strRet);
    }
    //---------------------------------
    //just truncate the values instead 
    function toCompressedStrTruncated()
    {
        //var sx = iToStr(156129);
        //Sys.println("compressed'"+sx+"'");
        
        var sz = rg.size();         // size of array to transmit
        var strRet = strName + cDP.format("%04X") + "00000000";
        var iDP = fWrap ? ((iCur - cDP + sz) % sz) : 0; //find the starting point
        
        //Sys.println(Lang.format("CMax=$1$ iCur=$2$ iDP=$3$ sz=$4$ cDP=$5$",[CMax,iCur, iDP, sz, cDP]));
        //Sys.println(rg);
        
       
        var iLast=rg[(iDP+1) % sz];
        for (var i = 0; i < cDP; ++i)
        {
            iDP = (iDP + 1) % sz;
            var s = iToStr(rg[iDP] - iLast);
            if (s.length() < 2)
            {
                Sys.println(i + " "  + rg[iDP] + " " + s);
                Sys.println("too short' "+s+"' " + (rg[iDP] - iLast));
            }
            strRet += s;
            iLast=rg[iDP];
        }
        
        //Sys.println("time: " + strRet);
        return(strRet);
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
        rc.draw(dc,ClrDkGray);
        drawLine(dc,rc.x0,rc.yCenter(),rc.x1,rc.yCenter(),ClrDkGray);
        dc.setPenWidth(1);

        for (var i = 0; i < rgser.size(); ++i)
        {
            var ser = rgser[i];
            if (ser.cDP > 1)
            {
		        var yMin = ser.min;
		        var yMax = ser.max;
		
		        fillRect(dc,rc.x0+18,rc.y0-1,67,2,ClrWhite);
		        fillRect(dc,rc.x0+18,rc.y1-2,67,2,ClrWhite);
		        
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