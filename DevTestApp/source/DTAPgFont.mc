using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

//---------------------------------------------------------
//---------------------------------------------------------
class PgFontDelegate extends Ui.BehaviorDelegate
{
    var view;
    //---------------------------------
    function initialize(view_) {view = view_;}
    
    //---------------------------------
    function onNextPage() {state.setPg(1);}     
    function onPreviousPage() {state.setPg(-1);}
         
    //---------------------------------
    function onSelect()
    {
        view.setFont(1);
    }  
    
    //---------------------------------
    function onBack()
    {
        view.setFont(-1);
        return(true);
    }  
    
    //---------------------------------
    function onSwipe(swipeevt) 
    {
        var swipe  = swipeevt.getDirection();
        switch (swipe)
        {
        case Ui.SWIPE_UP:
            return(view.setFont(1));
        case Ui.SWIPE_DOWN:
            return(view.setFont(-1));
        default:
        }
    }   
    
}

//---------------------------------------------------------
class PgFontView extends Ui.View
{
    const FntSample = FCnt;
    const FntList   = FCnt+1;
    const FntCount  = FCnt+2;
    var iFont = FntSample; //FCount = font list
    
    //---------------------------------
    function setFont(i) 
    {
        iFont = (iFont + i + FntCount) % FntCount;
        if (iFont < FCnt )
        {
		    Sys.println(
		      Lang.format("Font: $1$, cy=$2$, asc=$3$, desc=$4$",
		      [iFont, FntHeight[iFont], FntAscent[iFont], FntCYOff[iFont]]));
        }
        Ui.requestUpdate();
    }
    //---------------------------------
    function onUpdate(dc)
    {
        dc.setColor(ClrBG, ClrBG);
        dc.clear();

        var y = 4;
        fillRect(dc,0,0,cxScreen,FntAscent[F4],ClrYellow);
        y += drawTextY(dc,xCenter,y,F4,"Fonts",JC,ClrFG);
        
        if (iFont == FntSample)
        {
	        for (var f = F0; f <= FN3; ++f)
	        {
	            var str = f + " " + (isNumFont(f) ? "02468" : "aX2+g°");
	        
	            y+=drawTextY(dc,xCenter,y,f,str,JC,ClrFG); //"B0123456789"+"°" 
	        }
	        drawTextY(dc,xCenter,y,FX1,"12X",JC,ClrGreen);
	        drawTextY(dc,xCenter,y,FX2,"X34",JC,ClrYellow);
        }
        else if (iFont == FntList)
        {
            for (var f = F0; f <= FX2; ++f)
            {
                var s = Lang.format("$1$ $2$ $3$ $4$",
                    [f, FntHeight[f], FntAscent[f], FntCYOff[f]]);
                y+=drawTextY(dc,xCenter,y,F2,s,JT_C,ClrFG);
            }
        }
        else
        {
            var str = isNumFont(iFont) ? "1234567890" : "aX2+g°";
            var dim = dc.getTextDimensions(str,Fnt[iFont]);
            var width = dc.getTextWidthInPixels(str,Fnt[iFont]);
            if (width != dim[0]){Sys.println("width's don't match: " + width + ", " + dim);}
            
            y+= drawTextY(dc,xCenter,y,F3,iFont + " " + FntName[iFont],JC,ClrFG);

            var s = Lang.format("cy=$1$ asc=$2$ des=$3$",
                [FntHeight[iFont],FntAscent[iFont],FntCYOff[iFont]]);
            y+= drawTextY(dc,xCenter,y,F2,s,JC,ClrFG);

            y+= drawTextY(dc,xCenter,y,F2,dim.toString(),JC,ClrFG);
            
            drawTextY(dc,xCenter,y,iFont,str,JT_C,ClrFG);
            drawRect(dc,xCenter-width/2, y,width,FntAscent[iFont],ClrBlue);
            drawRect(dc,xCenter-width/2, y+FntAscent[iFont],width,FntHeight[iFont]-FntAscent[iFont],ClrGreen);
            drawRect(dc,xCenter-width/2, y,width,dim[1],ClrRed);
            
        }
    }
}