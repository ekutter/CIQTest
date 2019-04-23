using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Sensor;
using Toybox.Attention as Att;


//---------------------------------------------------------
//---------------------------------------------------------
class PgAccelDelegate extends Ui.BehaviorDelegate
{
    var view;
    //---------------------------------
    function initialize(view_) {view = view_;}
    
    //---------------------------------
    function onNextPage() {state.setPg(1);}     
    function onPreviousPage() {state.setPg(-1);} 
    function onMenu() 
    {   
        view.fText = !view.fText;
        return(true);
    }
    function onSelect()
    {
        //view.nextGraph();
        view.startStop();
    }
    function onBack()
    {
        view.nextScale();
        return(true);
    }
}

//---------------------------------------------------------
class PgAccelView extends Ui.View
{
    enum {SerX, SerY, SerZ, SerCount}
    enum {GraphAccel, GraphMag, GraphCount}
    
    var rggraph;
    var iGraphCur = GraphAccel;
    var iScale = 2000;
    var fRun = true;
    var fGraphAccel = true; 
    var fText = false;
    
    
    //---------------------------------
    function startStop() {fRun = !fRun;}
    //---------------------------------
    function nextGraph() {iGraphCur = (iGraphCur + 1) % GraphCount;}
    function nextScale() 
    {
        iScale += 1000;  
        if (iScale > 6000) {iScale = 1000;}
        for (var g = 0; g < GraphCount; ++g)
        {
            for (var s = 0; s < SerCount; ++s)
            {
                rggraph[g].rgser[s].min = -iScale;
                rggraph[g].rgser[s].max = iScale;
            }
        }
    }
    //---------------------------------
    function initialize() 
    {
        View.initialize();
        rggraph = [];
        for (var i = 0; i < 2; ++i)
        {        
	        var graph = new Graph();
	        graph.rgser.add( new GraphSer(ClrRed,-2000,2000,100));
	        graph.rgser.add( new GraphSer(ClrBlue,-2000,2000,100));
	        graph.rgser.add( new GraphSer(ClrYellow,-2000,2000,100));
	        rggraph.add(graph);
	    }
    }
    //---------------------------------
    function onShow()
    {    
        state.pgtimer.start(method(:onTimerTic),100,true);
    }
    
    //---------------------------------
    function onTimerTic() //every second
    {
        if (fRun)
        {
	        var info = Sensor.getInfo();
	
	        var fnt = F1;
	        if (info has :accel && info.accel != null)
	        {
	            var accel = info.accel;
	            for (var i = 0; i < SerCount; ++i)
	            {
	                rggraph[GraphAccel].rgser[i].add(accel[i]);
	            }
	        } 
	        if (info has :mag && info.mag != null) 
	        {
	            var mag = info.mag;
	            for (var i = 0; i < SerCount; ++i)
	            {
	                rggraph[GraphMag].rgser[i].add(mag[i]);
	            }
	        }
	    }
    }
    //---------------------------------
    function onHide()
    {
        state.pgtimer.stop();
    }
    
    //---------------------------------
    function onUpdate(dc)
    {
        dc.setColor(ClrBG,ClrBG);
        dc.clear();

        var y = 4;
        fillRect(dc,0,0,cxScreen,FntAscent[F4],ClrYellow);
        y += drawTextY(dc,xCenter,y,F4,"Accel",JC,ClrFG);
        y += drawTextY(dc, xCenter, y, F3, ((iGraphCur == GraphAccel) ? "Acc" : "Mag") + " " + iScale, JC, ClrFG);        
        
        var rc = new Rect(18,30,cxScreen-18, cyScreen-30);
        
        rggraph[iGraphCur].drawGraph(dc,rc);
                
        //-----------------
        var info = Sensor.getInfo();

        if (fText)
        {
            var fnt = F1;
            var data = (iGraphCur == GraphAccel) ? info.accel : info.mag;

            if (data != null)
            {
	            var graph = rggraph[iGraphCur];
	            for (var i = 0; i < SerCount; ++i)
	            {
	                var ser = graph.rgser[i];
	                y += drawTextY(dc, xCenter, y, fnt,Lang.format("$1$=$2$,$3$,$4$",[["X","Y","Z"][i],data[i],ser.min,ser.max]), JC, ClrFG);
	            }
	        }
        }

    }
}