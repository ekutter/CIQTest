using Toybox.System as Sys;
using Toybox.Math as Math;
using Toybox.Lang as Lang;

  //---------------------------------------------------------------------------
  // rgi - [TmMin0, TmMax0, Range0, TmMin1, TmMax1, Range1, ...]
  // rest: the first wave step
  //---------------------------------------------------------------------------
  class WaveMatch
  {
    enum {TmMin, TmMax, Range, FldCount}
    var rgi; //the wave definition
    var iStep = 0;
    var cStep; 
    function tmMin() {return (rgi[iStep * FldCount + TmMin]); }
    function tmMax() {return (rgi[iStep * FldCount + TmMax]); }
    function range() {return (rgi[iStep * FldCount + Range].abs()); }
    function sign () {return ((rgi[iStep * FldCount + Range])) / range(); } //1 or -1

    //state variables
    var valStart;
    var tmStart;
    var valMax;
    var valMin; //only used for the rest state
    var dur;

    var tmLast=0; //use this for the inflection points

    var rgstrStep = [];      //logging the steps
    var rgiSwingPoints = []; //logging the steps

    function fSuccess() {return (iStep == cStep);} //we made it to the end

    //-------------------------------------------
    function initialize(rgi_)
    {
      rgi = rgi_;
      cStep = rgi.size() / FldCount;
      reset();
    }
    //-------------------------------------------
    function reset() { resetInternal(true); }
    function resetInternal(fClearLogs)
    {
      iStep = 0;
      valStart = 0;
      tmStart = -1;
      dur = 0;
      valMax = IntMin;
      valMin = IntMax; //used for rest only
      if (fClearLogs)
      {
	      rgstrStep = [];
	      rgiSwingPoints = [];
	  }
    }
    //-------------------------------------------
    function nextStep(tm, val)
    {
      //log step
      rgstrStep.add(stepString());
      rgiSwingPoints.add(tmLast);
      iStep++;
      valStart = -valMax; //signs are backwards
      tmStart = tm;
      valMax = IntMin;
    }

    //-------------------------------------------
    function addPoint(tm, val)
    {
      val = val * sign();
      if (tmStart == -1) //this is the first one
      {
        tmStart = tm;
        valStart = val;
        rgiSwingPoints.add(tm);
      }
      if (iStep == 0) //reset step
      {
        if (val < valMin){ valMin = val;}
        if (val > valMax){ valMax = val;}

        if ((valMax - valMin) > range()) //went out of the rest range
        {
          //no longer resting - see if we can move on tothe swing
          if (((tm - tmStart) < tmMin()) || // we didn't rest long enough
              (val == valMin))            // we are Slowing down - not the back swing
          {
            resetInternal(true);
          }
          else
          {
            nextStep(tm, val); //we've rested long enough and we are starting the back swing
          }
        }
      }
      else if (val < valMax)
      {
        //done with acceleration
        dur = tm - tmStart;
        if ((dur < tmMin()) || //too fast
            (dur > tmMax()) || //too slow
            ((valMax - valStart) < range())) //didn't go up enough
        {
          rgstrStep.add("Fail: " + stepString());
          resetInternal(false);
        }
        else
        {
          nextStep(tm, val);
        }
      }
      else
      {
        valMax = val;
      }
      tmLast = tm;
      return (fSuccess());
    }

    //-------------------------------------------
    function stepString()
    {
      return (Lang.format("$1$: start: $2$ dur: $3$ < $4$ < $5$, rg: $6$ < $7$ sign: $8$",
        [iStep, tmStart, tmMin(), dur, tmMax(),
        range(), (valMax - valStart) * sign(), sign()]));
    }
    //-------------------------------------------
    function toString() { return (strJoin(",",rgiSwingPoints)); }
    function toLogString()
    {
      var strOut = strJoin("\n",rgstrStep);
      if (!fSuccess()) {strOut += "\n" + stepString();}
      return (strOut);
    }

  }
