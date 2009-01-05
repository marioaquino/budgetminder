/* 
 This file was generated by Dashcode.  
 You may edit this file to customize your widget or web page 
 according to the license.txt file included in the project.
 */

// Properties set by attributes panel
var updateInterval;

// Monitor object (see CommandMonitor.js)
var budgetMonitor;
var monitorRunning;

//
// Function: initMonitor()
// Called by load() when widget starts up to set up and start the monitors
//
function initMonitors()
{
	var callback = function(line) {
		//TODO: Remove this alert
        alert(line);

        if (line.indexOf("Budget=") == 0) {
            setTextField("textfield-monthly-budget", line.substring(7));
        } 
        else if (line.indexOf("EndDate=") == 0) {
            var endDate = line.substring(8);
            setElementText("text-until", endDate);
            setTextField("textfield-cycle-date", endDate);
        } 
        else if (line.indexOf("PercentageUsed=") == 0) {
            setGaugeValue("gauge1", line.substring(15));
        } 
        else if (line.indexOf("Remaining=") == 0)  {
            setElementText("text-amount-remaining", line.substring(10));            
        } 
        else if (line.indexOf("Spent=") == 0) {
            setElementText("text-amount-spent", line.substring(6));
        }
    }
	budgetMonitor = new BudgetMonitor(callback);
    budgetMonitor.start();

    monitorRunning = true;
}



//
// Function: makeMaxTracker(callback, min, valuesToTrack)
// Creates a function that tracks the maximum value seen recently to
// allow gague values to be automatically scaled
//
// callback: Your function that will be called with (value, max) parameters
// min: Clamp values less than this to min (default 1.0)
// valuesToTrack: How much history to keep (default 60 values)
//
// Return the tracker function
//
function makeMaxTracker(callback, min, valuesToTrack)
{
    if (valuesToTrack == null) {
        valuesToTrack = 60;
    }

    if (min == null) {
        min = 1.0;
    }

    var trackValues = new Array();

    var tracker = function (value)
    {
        trackValues.push(value);
        if (trackValues.length > valuesToTrack) {
            trackValues.shift();
        }

        var max = min;
        for (var i = 0; i < trackValues.length; i++) {
            if (trackValues[i] > max) {
                max = trackValues[i];
            }
        }

        callback(value, max);
    };

    return tracker;
}

//
// Function: setElementText(elementName, elementValue)
// Set the text contents of an HTML div
//
// elementName: Name of the element in the DOM
// elementValue: Text to display in the element
//
function setElementText(elementName, elementValue)
{
    var element = document.getElementById(elementName);
    if (element) {
        element.innerText = elementValue;
    }
}

//
// Function: setGaugeValue(gaugeId, value)
// Sets the value of one of the monitor gauges
//
// gaugeId: Gauge to set
// value: Value to set gauge to
//
function setGaugeValue (gaugeId, value)
{
    var element = document.getElementById(gaugeId);
    if (element != null && element.object != null && element.object.setValue != null) {
        element.object.setValue(value);
    }
}

function updateGauge(event) {
    var val = getExpenseValue();
	if (val.length > 0) {
    	budgetMonitor.callWithParam('expense ' + val);
    	clearTextField();
	}
}

function getExpenseValue() {
	return getTextValue("textfield-expense");
}

function clearTextField() {
    setTextField("textfield-expense", "");
}

function getTextValue(name) {
	return document.getElementById(name).value;
}

function setTextField(name, value) {
    document.getElementById(name).value = value;
}

//
// Function: load()
// Called by HTML body element's onload event when the widget is ready to start
//
function load()
{
    dashcode.setupParts();

    // Get the properties
    updateInterval = +attributes.updateInterval;
    if (!updateInterval) {
        updateInterval = 1;
    }

    // Set up command monitors
    initMonitors();
}

//
// Function: remove()
// Called when the widget has been removed from the Dashboard
//
function remove()
{
    // Stop any timers to prevent CPU usage
    // Remove any preferences as needed
    // widget.setPreferenceForKey(null, dashcode.createInstancePreferenceKey("your-key"));
}

//
// Function: hide()
// Called when the widget has been hidden
//
function hide()
{
    // Stop monitor timers to prevent CPU usage
    if (monitorRunning) {
        budgetMonitor.stop();
        monitorRunning = false;
    }
}

//
// Function: show()
// Called when the widget has been shown
//
function show()
{
    // Restart any timers that were stopped on hide
    if (monitorRunning === false) {
        budgetMonitor.start();
        monitorRunning = true;
    }
}

//
// Function: sync()
// Called when the widget has been synchronized with .Mac
//
function sync()
{
    // Retrieve any preference values that you need to be synchronized here
    // Use this for an instance key's value:
    // instancePreferenceValue = widget.preferenceForKey(null, dashcode.createInstancePreferenceKey("your-key"));
    //
    // Or this for global key's value:
    // globalPreferenceValue = widget.preferenceForKey(null, "your-key");
}

//
// Function: showBack(event)
// Called when the info button is clicked to show the back of the widget
//
// event: onClick event from the info button
//
function showBack(event)
{
    var front = document.getElementById("front");
    var back = document.getElementById("back");

    if (window.widget) {
        widget.prepareForTransition("ToBack");
    }

    front.style.display="none";
    back.style.display="block";

    if (window.widget) {
        setTimeout('widget.performTransition();', 0);
    }
}

//
// Function: showFront(event)
// Called when the done button is clicked from the back of the widget
//
// event: onClick event from the done button
//
function showFront(event)
{
    var front = document.getElementById("front");
    var back = document.getElementById("back");

	updateConfigSettings();

    if (window.widget) {
        widget.prepareForTransition("ToFront");
    }

    front.style.display="block";
    back.style.display="none";

    if (window.widget) {
        setTimeout('widget.performTransition();', 0);
    }
}

function updateConfigSettings() {
	var budget = 'budget=' + getTextValue("textfield-monthly-budget");
	var cycleDate = 'cycleDate=' + getTextValue("textfield-cycle-date");
    budgetMonitor.callWithParam("update '" + budget + "' " + cycleDate);
}

if (window.widget)
{
    widget.onremove = remove;
    widget.onhide = hide;
    widget.onshow = show;
    widget.onsync = sync;
}
