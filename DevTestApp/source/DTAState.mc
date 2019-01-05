using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Attention as Att;
using Toybox.Timer;


//---------------------------------------------------------
//---------------------------------------------------------
class State
{
    enum {PgHome, PgInput, PgInputBehavior, PgFont, PgColors, PgTones, PgAccel, PgCount}
    var pgCur = PgHome;
    var pgtimer = new Timer.Timer();  //this gets reused by multiple pages so we don't run out of timers
    
    
    //---------------------------------
    function initialize()
    {
    }
    
    //---------------------------------
    function onTimerTic()
    {
    }
    
    //---------------------------------
    function done()
    {
    }
    
    //---------------------------------
    function setPg(increment)
    {
        //logMsg.logMsg("setpg");
        var pgLast = pgCur;
        do
        {
            pgCur = (pgCur + increment + PgCount) % PgCount;
        } while (!isPgVisible(pgCur));
        logMsg.logMsg(Lang.format("setPg($1$) $2$ -> $3$",[increment,pgLast,pgCur]));
        
        switch (pgCur)
        {
        case PgHome: return(Ui.switchToView(new PgHomeView(), new PgHomeDelegate(), Ui.SLIDE_IMMEDIATE));
            //return;
            
        case PgInput:
        {
            var view=new PgInputView();
            Ui.switchToView(view, new PgInputDelegate(view), Ui.SLIDE_IMMEDIATE);
            return;
        }
        case PgInputBehavior:
        {
            var view=new PgInputView();
            Ui.switchToView(view, new PgInputBehaviorDelegate(view), Ui.SLIDE_IMMEDIATE);
            return;
        }
        
        case PgFont: 
        {
            var view=new PgFontView();
            Ui.switchToView(view, new PgFontDelegate(view), Ui.SLIDE_IMMEDIATE);
            return;
        }
        case PgColors: return(Ui.switchToView(new PgColorsView(), new PgColorsDelegate(), Ui.SLIDE_IMMEDIATE));
        case PgTones: 
        {
            var view=new PgTonesView();
            Ui.switchToView(view, new PgTonesDelegate(view), Ui.SLIDE_IMMEDIATE);
            return;
        }
        case PgAccel: 
        {
            var view=new PgAccelView();
            Ui.switchToView(view, new PgAccelDelegate(view), Ui.SLIDE_IMMEDIATE);
            return;
        }
        default:
            return;
        }
    }

    //---------------------------------
    function isPgVisible(pg)
    {
        switch (pg)
        {
        case PgHome:
        case PgInput:
        case PgInputBehavior:
        case PgFont: 
        case PgColors: 
        case PgAccel: //probably should test for sensor availability
            return(true); //always
        case PgTones:
            return(Att has :playTone);
        default:
            return(false);
        }
    }    
}