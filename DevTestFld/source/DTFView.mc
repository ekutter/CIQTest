using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.FitContributor as Fit;
using Toybox.Attention as Att;
using Toybox.Activity as Act;

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
class DevTestFldView extends Ui.DataField 
{
    var cLayout = 0;
    var cCompute = 0;
    var cUpdate = 0;
    
    var alt = null;
    var asc = 0;
    var fldAlt;
    var fldAsc;
    var fldPressure;

    var dur=0;
    var timerstate = Activity.TIMER_STATE_OFF;
    //-------------------------------------------
    function initialize() 
    {
        DataField.initialize();
        //fldAlt = createField("Alt2", 30, Fit.DATA_TYPE_FLOAT, {:mesgType=>Fit.MESG_TYPE_RECORD, :units=>"ft"});
        //fldAsc = createField("Asc2", 31, Fit.DATA_TYPE_FLOAT, {:mesgType=>Fit.MESG_TYPE_RECORD, :units=>"ft"});
        //fldPressure = createField("Pres2", 32, Fit.DATA_TYPE_FLOAT, {:mesgType=>Fit.MESG_TYPE_RECORD, :units=>"ft"});
    }

    //-------------------------------------------
    function onLayout(dc) 
    {
        cLayout++;
    }
    
    //-------------------------------------------
    function logMsg(str)
    {
        Sys.println(Lang.format("$1$: $2$",[strTimeOfDay(),str]));
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

    //-----------------------------------------------------
    // onHide doesn't get called for data fields
    var cShow = 0;
    function onShow()
    {
//        if (Att has :vibrate)
//            {Att.vibrate([new Att.VibeProfile(  100,400 )]);}
    
        logMsg("onShow: " + strDur(dur) + " " + cShow);
        cShow++;
    }

    //-------------------------------------------
    function compute(info) 
    {
        //logMsg("compute");
        //fldAlt.onUpdate();
        
        cCompute++;
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate)
        {
        }
        
        timerstate = info.timerState;
        dur = info.timerTime;
        
        if (info has :altitude)
        {
            alt = info.altitude;
            asc = info.totalAscent;
            
            if ((fldAlt != null) && (alt != null))
            {
                fldAlt.setData(alt * FtPerMeter);
                //Sys.println(alt*FtPerMeter);
            }
            if ((fldAsc != null) && (asc != null))
            {
                fldAsc.setData(asc * FtPerMeter);
            }
            
            if ((fldPressure != null) && (info.ambientPressure != null))
            {
                fldPressure.setData(info.ambientPressure);
            } 
        }
    }

    //-------------------------------------------
    function onUpdate(dc) 
    {
        //logMsg("onUpdate cUpdate=" + cUpdate);
        var cx = dc.getWidth();
        var cy = dc.getHeight();
        cUpdate++;
        dc.setColor(ClrWhite, ClrWhite);
        dc.clear();
        
        dc.setColor(ClrRed,ClrTrans);
        dc.drawRectangle(4,4,cx-8,cy-8);
        
        dc.setColor(ClrGreen,ClrTrans);
        dc.setPenWidth(4);
        dc.drawRectangle(0,0,cx,cy);
        dc.setPenWidth(1);
        
        dc.setColor(ClrBlack,ClrTrans);
        var y = -dc.getFontDescent(F2)+2;// dc.getFontHeight(F2);
        var str;

        var verCIQ = Sys.getDeviceSettings().monkeyVersion;
        //verCIQ = verCIQ[0] * 10000 + verCIQ[1]*100 + verCIQ[2]; // [3, 1, 4] => 30104
        
        str = Lang.format("$1$",[strDur(dur)]);  
        dc.drawText(cx/2,y,F2,str, JC);
        y += dc.getFontHeight(F2);  

        str = Lang.format("$3$[$1$,$2$] ",[cx,cy,strObscure()]);  
        dc.drawText(cx/2,y,F0,str, JC);
        y += dc.getFontHeight(F2);  

        var stats = Sys.getSystemStats();
        var strMem = Lang.format("mem: $1$k/$2$k",[stats.usedMemory/1024,stats.totalMemory/1024]);
        dc.drawText(cx/2,y,F1,strMem, JC);
        y += dc.getFontHeight(F1);  
        
        //str = Lang.format("e=$1$,a=$2$",[strAlt(alt),strAlt(asc)]);
        var lvl = Sys.getSystemStats().battery;
        str = Lang.format("$1$% $2$.$3$.$4$",[lvl.format("%.2f"),verCIQ[0],verCIQ[1],verCIQ[2]]);  
        dc.drawText(cx/2,y,F1,str, JC);

        y += dc.getFontHeight(F1);  
        //str = Lang.format("$1$,$2$,$3$,Sh=$4$",[cLayout, cCompute,cUpdate,cShow]);  
        str = Lang.format("upd=$1$,show=$2$",[cUpdate,cShow]);  
        dc.drawText(cx/2,y,F1,str, JC);

        if (xyTap != null)
        {
            y += dc.getFontHeight(F1);  
            dc.drawText(cx/2,y,F1,xyTap, JC);
        }

        if (!fInstinct2) 
        {
            var info = Act.getActivityInfo();  //might not be there on the Instinct 2 - crashing on the Instinct 2
            if ((info has :distanceToDestination) && (info.distanceToDestination != null))
            {
                var strEleAtDest = "-";
                var strEleAtNext = "-";
                var strOffCourseDist = "-"; 
    
                if (info has :elevationAtDestination){strEleAtDest = formatFloatOrNull(info.elevationAtDestination);}
                if (info has :elevationAtNextPoint){strEleAtNext = formatFloatOrNull(info.elevationAtNextPoint);}
                if (info has :offCourseDistance){strOffCourseDist = formatFloatOrNull(info.offCourseDistance);}
    
                var strCrs = Lang.format("$1$,$2$,$3$,$4$,$5$", [
                    strEleAtDest,strEleAtNext,strOffCourseDist,
                    (info has :nameOfDestination) ? info.nameOfDestination : "-",
                    (info has :nameOfNextPoint) ? info.nameOfNextPoint : "-"]);
    
                y += dc.getFontHeight(F1);
                dc.drawText(cx/2,y,F1,strCrs, JC);
    
                strCrs = Lang.format("toDest: $1$ / $2$", 
                  [strDist(info.distanceToNextPoint),strDist(info.distanceToDestination)]);  
                y += dc.getFontHeight(F1);
                dc.drawText(cx/2,y,F1,strCrs, JC);
            }
            else 
            {
                y += dc.getFontHeight(F1);
                dc.drawText(cx/2,y,F1,"no course info", JC);
            }
        }
        
        y += dc.getFontHeight(F1);  
        dc.drawText(cx/2,y,F1,"Dbg="+fDbgMode, JC);

    }
    function formatFloatOrNull(v)
    {
        return((v == null) ? "null" : v.format("%.1f"));
    }
}
