using Toybox.WatchUi;

class TestMapSimpleFldView extends WatchUi.SimpleDataField {

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "My Label";
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    var i = 0;
    function compute(info) {
        // See Activity.Info in the documentation for available information.
        i += 1;
        return i;
    }

}