using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics;
using Toybox.Sensor;
using Toybox.Timer;
using Toybox.Math;
//---------------------------------------------------------
//---------------------------------------------------------
class GolfSwingDelegate extends Ui.BehaviorDelegate 
{
    var view;
    //---------------------------------
    function initialize(view_) 
    {
        view = view_;
    }
    
    //---------------------------------
    //function onNextPage() {state.setPg(1);}     
    //function onPreviousPage() {state.setPg(-1);} 
    function onMenu() 
    {   
        return(true);
    }
    //---------------------------------
    function onSelect()
    {
        //view.nextGraph();
        view.startStop();
    }
    //---------------------------------
    function onBack()
    {
        //view.nextScale();
        return(false); //let it exit
    }
    
    //---------------------------------
    function onNextPage()
    {
        Sys.println("onNextPage");
    
        state.http.sendDataRequest("swing", view.toData());
    }
}
//---------------------------------------------------------
//---------------------------------------------------------
class GolfSwingView extends Ui.View 
{
    const ScaleRec = 3000;
    const SampleRate = 25;
    const SampleDur = 6;
    
    var data = ["swing","again"];
    
    enum {SerX, SerY, SerZ, SerCount}
    
    var timer = new Ui.Timer.Timer();
    var rgser;
    var graph;
    var iScale = 3000;
    var fRun = true;
    
    var serTm;
    var cSample = 0;  
    //---------------------------------
    // FIR: count,a,b,c,d,e
    // WV: compressed(a,b,c,...) 0 -(62*62)
    // <ser>: compressed series - ser [tm,aX,yX,zX,mX,mY,mZ, ...]
    // 
    //  
    var t = 0;
    function toData()
    {
        var str = "";
        str += "fi" + strFromNumArray(firWave)+",";
        str += "wv" + strFromNumArray(rgiMatch)+",";
        str += serTm.toCompressedStrTruncated(); //first add the time series
        for (var s = 0; s < SerCount; ++s)
        {
            //Sys.println(rgser[s].rg);
            str += rgser[s].toCompressedStr();
        }
        //Sys.println(str);
        //Sys.println("len="+str.length());
        //Sys.println(5 / t);
        return(str);
    }
    //---------------------------------
    function strFromNumArray(rg)
    {
    	var strRet = rg.size() + ".";
    	strRet += strJoin(".",rg);
    	return(strRet);
    }
        
    //---------------------------------
    function startStop() 
    {
        fRun = !fRun;
        if (fRun){reset();}
    }
    //---------------------------------
    function nextGraph() {}
    function nextScale() 
    {
        iScale += 1000;  
        if (iScale > 6000) {iScale = 1000;}
        for (var s = 0; s < SerCount; ++s)
        {
            rgser[s].min = -iScale;
            rgser[s].max = iScale;
        }
    }
    //---------------------------------
    var firFilter;
    //var firWave = [0.05f, 0.1f, 0.2f, 0.3f, 0.2f, 0.1f, 0.05f ];
    var firWave = [50, 100, 200, 300, 200, 100, 50 ];
    
    function initialize() 
    {
        //testDetect();
        //testDetect();
        //testDetect();
        
        //var options = {:coefficients => [ 0.1f, 0.8f, 0.1f ], :gain => 1f};
        var options = {:coefficients => firWave, :gain => 0.001f};
        //var options = {:coefficients => [ -0.0278f, 0.9444f, -0.0278f ], :gain => 0.001f}; //from pitch counter
        firFilter = new Math.FirFilter(options);
        View.initialize();
        reset();
    }
    //---------------------------------
    function reset()
    {
        graph = new Graph();
        rgser = graph.rgser;
        for (var i = 0; i < 2; ++i)
        {        
            rgser.add( new GraphSer("aX", ClrRed,   -ScaleRec,ScaleRec,SampleRate * SampleDur));
            rgser.add( new GraphSer("aY", ClrBlue,  -ScaleRec,ScaleRec,SampleRate * SampleDur));
            rgser.add( new GraphSer("aZ", ClrGreen, -ScaleRec,ScaleRec,SampleRate * SampleDur));
        }
        serTm = new GraphSer("tm", ClrWhite,0,1,SampleRate * SampleDur); // not for graphing, just for keeping time
        cSample = 0;
    }
    //---------------------------------
    function onShow()
    {    
        var options = {:period => 1, :sampleRate => SampleRate, :enableAccelerometer => true};
        Sensor.registerSensorDataListener(method(:accel_callback), options);
    }
    //---------------------------------
    function onHide()
    {
        Sensor.unregisterSensorDataListener();
    }
    
    
    //---------------------------------
    var rgtmTest = [
		0,50,100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,1050,1100,1150,
		1200,1250,1300,1350,1400,1450,1500,1550,1600,1650,1700,1750,1800,1850,1900,1950,2000,2050,2100,
		2150,2200,2250,2300,2350,2400,2450,2500,2550,2600,2650,2700,2750,2800,2850,2900,2950,3000,3050,
		3100,3150,3200,3250,3300,3350,3400,3450,3500,3550,3600,3650,3700,3750,3800,3850,3900,3950,4000,
		4050,4100,4150,4200,4250,4300,4350,4400,4450,4500,4550,4600,4650,4700,4750,4800,4850,4900,4950,
		5000,5050,5100,5150,5200,5250,5300,5350,5400,5450,5500,5550,5600,5650,5700,5750,5800,5850,5900,5950];

    var rgvalTest = [
		71,74,75,86,92,92,89,103,98,99,84,97,100,86,83,91,103,92,96,99,97,82,95,102,97,99,107,101,94,100,97,
		99,105,97,94,100,99,96,93,91,83,93,94,90,93,99,105,96,84,93,95,89,95,95,98,99,98,91,96,97,89,99,94,
		97,93,104,153,151,180,379,503,590,691,910,945,1077,1217,1471,1673,1770,1753,1492,892,177,-598,-1032,
		-1133,-964,-619,-32,980,2788,5007,3315,2268,1255,1369,1582,1346,573,-36,-269,-369,-456,-423,-260,-272,
		-335,-239,-114,-41,-1,63,82,157,228,256,439,519,520];

    var rgiMatch =[
        //tmMin, tmMax, range
        300,100000,300, 
        200,650,1000,  
        200,650,-1000, 
        200,500,2000, 
        100,1000,-1000
      ];

    //---------------------------------
    var wavematch = new WaveMatch(rgiMatch);
    function testDetect()
    {
        Sys.println("testDetect");
        for (var i = 0; i < rgtmTest.size(); ++i)
        {
            Sys.println(rgtmTest[i]);
            if (wavematch.addPoint(rgtmTest[i],rgvalTest[i]))
            {
                break;
            }
        }
        Sys.println(wavematch.fSuccess());
        Sys.println("SwingPoints: " + wavematch.rgiSwingPoints);
        wavematch.reset();
    }
    
    //---------------------------------
    // Callback to receive accel data
    var mX;
    var mY;
    var mZ;
    var mYFIR;
    function accel_callback(sensorData) {
        //Sys.println("X" + sensorData.accelerometerData.x);
        //mX = mFilter.apply(sensorData.accelerometerData.x);
        //Sys.println("+" + mX);
        mX = sensorData.accelerometerData.x;
        mY = sensorData.accelerometerData.y;
        mYFIR = firFilter.apply(sensorData.accelerometerData.y);
        for (var i = 0; i < mYFIR.size(); ++i) {mYFIR[i] = mYFIR[i].toNumber();}
        //Sys.println(mY);
        //Sys.println("FIR: " + mYFIR);
        mZ = sensorData.accelerometerData.z;
        onAccelData();
    }
    //---------------------------------
    var cSwing = 0;
    function onAccelData()
    {
        if (fRun)
        {
//            Sys.println(mX.size() + ", " + mX);
//            Sys.println(mY.size() + ", " + mY);
//            Sys.println(mZ.size() + ", " + mZ);
            for (var i = 0; i < mX.size(); ++i)
            {
                var tm = cSample *(1000/SampleRate);
                serTm.add(tm);
                cSample++;
                rgser[SerX].add(mX[i]);
                rgser[SerY].add(mY[i]);
                rgser[SerZ].add(mZ[i]);
                
                if (wavematch.addPoint(tm,mYFIR[i]))
                {
                    cSwing++;
                    //tone(Attention.TONE_KEY);
                    vibrate(100,1200);
                    wavematch.reset();
                }
            }
        }
    }
    //---------------------------------
    function onUpdate(dc)
    {
        dc.setColor(ClrBlack,ClrBlack);
        dc.clear();

        var y = 4;
        fillRect(dc,0,0,cxScreen,FntAscent[F4],ClrYellow);
        y += drawTextY(dc,xCenter,y,F4,cSwing,JC,ClrWhite);
        //y += drawTextY(dc,xCenter,y,F4,"Accel",JC,ClrWhite);
        y += drawTextY(dc, xCenter, y, F3, iScale, JC, ClrWhite);        
        
        var rc = new Rect(18,30,cxScreen-18, cyScreen-30);
        
        graph.drawGraph(dc,rc);
                
        drawTextY(dc,xCenter,cyScreen-10,F3,(state.http.fPending ? "pend " : "") + state.http.iSend,JC_BL,ClrWhite);
    }
}
