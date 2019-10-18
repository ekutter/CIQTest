using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Communications as Comm;


//---------------------------------------------------------
//---------------------------------------------------------
class TestWebRequestView extends Ui.View 
{
    const ClrWhite = 0xFFFFFF;//Gfx.COLOR_WHITE;
    const ClrBlack = 0x000000;//Gfx.COLOR_BLACK;
    enum {F0, F1, F2, F3, F4,FN0, FN1, FN2, FN3, FX1, FX2} //fonts
    enum {JR, JC, JL, JVC=4, JCC=5, JCORE=7 } //justify

    var tmRequest = null;       //what was the time of the last request - null=no request pending
    var strLastSuccess = "--";  //what time did wwe last get a successful response
    var tmLastSuccess = 0;      //effectively boot time to last success
    var tmStart;                //what time did we start the app
    var cRequest = 0;           //how many requests have been made
    var cErr = 0;               //how many error responses have we had
    var cResponse;              //how many successful responses did we get
    
    var cReqInt = 3300; 
    
    //---------------------------------
    function initialize() 
    {
        tmStart = Sys.getTimer();
        View.initialize();
        Sys.println("Req Int: " + cReqInt);
        Sys.println("phone connected: " + Sys.getDeviceSettings().phoneConnected); 

        cResponse = App.getApp().getProperty("cResponse");
        if (cResponse == null) {cResponse = 0;}        

        var tmResponse = App.getApp().getProperty("tmResponse");

        if ((tmResponse == null) || (tmResponse > Sys.getTimer()))
        {
            Sys.println("reboot detected");
            cResponse = 0;
            App.getApp().setProperty("cResponse",0);
            App.getApp().setProperty("tmResponse",0);
        }
        else
        {
            Sys.println("init cResponse: " + cResponse);
        }
    }

    //---------------------------------
    var tmLastReq = 0;
    function onTimerTic() //every second
    {
        //make a request if we don't have one pending
        if ((tmRequest == null) && (Sys.getTimer() > (tmLastReq+cReqInt)))
        {
            makeRequest();
            tmLastReq = Sys.getTimer();
        }
        Ui.requestUpdate(); //update the display regardless
    }
    
    //---------------------------------
    // Receive the data from the web request
    var strMsg;
    var lastResponseCode = 0;
    var lastUnknownCode = "";
    var c104 = 0;
    var c2 = 0;
    var cOther = 0;
   
    function onReceive(responseCode, data) 
    {
        //Sys.println("OnReceive");
        lastResponseCode=responseCode;
        if (responseCode == 200) 
        {
            cResponse++;
            App.getApp().setProperty("cResponse",cResponse);
            App.getApp().setProperty("tmResponse",Sys.getTimer());
        
            if (data instanceof Lang.String) 
            {
                //Sys.println("string");
                strMsg = data;
            }
            else if (data instanceof Dictionary) 
            {
                //Sys.println("dict");
                // Print the arguments duplicated and returned by jsonplaceholder.typicode.com
                var keys = data.keys();
                strMsg = "";
                for( var i = 0; i < keys.size(); i++ ) 
                {
                    strMsg += Lang.format("$1$: $2$\n", [keys[i], data[keys[i]]]);
                }
            }
            tmRequest = null;
            strLastSuccess = strTimeOfDay(false);
            tmLastSuccess = Sys.getTimer();
            //Sys.println(strMsg);
            Ui.requestUpdate();
        }
        else
        {
            if (responseCode == -104) {++c104;}
            else if (responseCode == -2) {++c2;}
            else {cErr++; lastUnknownCode=responseCode;}
            
            tmRequest = null;
            if (cErr <= 10) //only print the first 10.  Fills up the log file after that
            {
                Sys.println(strTimeOfDay(true) + ", error=" + responseCode);
            }
        }
    }

    //---------------------------------
    function makeRequest() 
    {
        //don't bother making the request if there is no phone connected
        //if (Sys.getDeviceSettings().phoneConnected)
        {
            //Sys.println("MakeRequest");
            tmRequest = Sys.getTimer();
            cRequest++;
            
            Comm.makeWebRequest(
                "https://jsonplaceholder.typicode.com/todos/115",
                {},
                {"Content-Type" => Comm.REQUEST_CONTENT_TYPE_URL_ENCODED},
                method(:onReceive));
        }
    }

    //---------------------------------
    //  display Lines
    //     Duration since app started
    //     count of successful responses since boot
    //     count of errors, current memory usage in k
    //     DurPend is time since the last request
    //     current clock time - time of last successful response
    //
    function onUpdate(dc) 
    {
        var xCenter = dc.getWidth() / 2;
        var y = 0;
        var fnt = F2;
        var cyLine = dc.getFontAscent(fnt)+2;

        dc.setColor(ClrWhite, ClrBlack);
        dc.clear();
        
        y += cyLine/4;
        dc.drawText(xCenter, y, fnt, strDur(Sys.getTimer() - tmStart), JC);
        y += cyLine;
        dc.drawText(xCenter, y, fnt, "cRes=" + cResponse, JC);
        y += cyLine;
        dc.drawText(xCenter, y, fnt, "2=" + c2 + ", 104=" + c104, JC);
        y += cyLine;
        dc.drawText(xCenter, y, fnt, "UK=" + cErr + ", interval=" + (cReqInt/1000.0).format("%.1f"), JC);
        y += cyLine;
        dc.drawText(xCenter, y, fnt, "DurPend=" + 
          ((tmRequest != null) ? strDur(Sys.getTimer() - tmRequest) : "0:00"), JC);
        y += cyLine;
        dc.drawText(xCenter, y, fnt, strTimeOfDay(true) + " - " + strLastSuccess, JC);
        y += cyLine;
        dc.drawText(xCenter, y, fnt, "last=" + lastResponseCode + ", UK=" + lastUnknownCode, JC);
        y += cyLine;
        dc.drawText(xCenter, y, fnt, "boot:"+strDur(Sys.getTimer()), JC);
    }
}
