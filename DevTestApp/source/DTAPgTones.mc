using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Attention as Att;

//---------------------------------------------------------
//---------------------------------------------------------
class PgTonesDelegate extends Ui.BehaviorDelegate
{
    var view;
    //---------------------------------
    function initialize(view_) {view = view_; Ui.BehaviorDelegate.initialize();}
    
    //---------------------------------
    function onNextPage() {state.setPg(1);}     
    function onPreviousPage() {state.setPg(-1);}
         
    //---------------------------------
    function onSelect()
    {
        view.setTone(1);
    }  
    
    //---------------------------------
    function onBack()
    {
        view.setTone(-1);
        return(true);
    }  
    
    //---------------------------------
    function onSwipe(swipeevt) 
    {
        var swipe  = swipeevt.getDirection();
        switch (swipe)
        {
        case Ui.SWIPE_UP:
            return(view.setTone(-1));
        case Ui.SWIPE_DOWN:
            return(view.setTone(1));
        default:
            return(false);
        }
    }   
    
}

//---------------------------------------------------------
class PgTonesView extends Ui.View
{
    const ToneCount  = 18;
    var iTone = ToneCount-1; //FCount = font list
    
    //---------------------------------
    function setTone(i) 
    {
        iTone = (iTone + i + ToneCount) % ToneCount;
        Att.playTone(iTone % 18); //this page would never be shown if tones don't exist
        Ui.requestUpdate();
    }
    //---------------------------------
    function onUpdate(dc)
    {
        dc.setColor(ClrBG,ClrBG);
        dc.clear();

        var y = 4;
        fillRect(dc,0,0,cxScreen,FntAscent[F4],ClrYellow);
        y += drawTextY(dc,xCenter,y,F4,"Tones",JC,ClrFG);
        
        y += FntHeight[F4];        
        y+= drawTextY(dc,xCenter,y,FN3,iTone,JC,ClrFG);
   }
}