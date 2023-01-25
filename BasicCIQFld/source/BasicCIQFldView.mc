using Toybox.WatchUi;
using Toybox.SensorHistory as Hist;
using Toybox.System as Sys;


class BasicCIQFldView extends WatchUi.SimpleDataField {

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "My Label";
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    var cCompute = 0;
    function compute(info) {
        // See Activity.Info in the documentation for available information.
        cCompute++;
        Sys.println("compute");
        if ((Toybox has :SensorHistory) && (Hist has :getTemperatureHistory))
        {        
          Sys.println("hasSensorHistory");
          var tempIter = Hist.getTemperatureHistory({:period => 1});
          Sys.println(tempIter.next());
          var tempNext = tempIter.next();
          if (tempNext != null)
          {
              var tempInternal = tempNext.data;
              Sys.println("temp:" + tempInternal);
          }
        }
        
        return("0:00");
    }

}