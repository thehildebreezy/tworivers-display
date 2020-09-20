/**
 * Creates a date time module that will consistently update the date and time
 * Also displays moonphase, because why not
 * Icons from Erik Flowers: https://erikflowers.github.io/weather-icons/
 * @author Tanner Hildebrand
 * @version 1.0
 */
import QtQuick 2.0
import QtGraphicalEffects 1.0
import "source/weather_icons/weather-icons-master/iconmap.js" as IconMap

/** Base item, when called from outside as Datetime object */
Item {
	/** Sets the default text size of the module */
	property int textSize: 18
	/** Sets the default emphatic text size */
	property int textEmph: 24
	/** Sets the default text color to white */
	property string fontColor: "white"

    /** Start a timer to update the modules display ever 500ms */
	Timer  {
		id: clockTimer 
		interval: 500 // 500ms
		repeat: true  // repeat ever interval
		running: true // immediatelly start running
		onTriggered: startTimeCheck()
	}

	/** Fired every 500ms to update the Datetime display */
	function startTimeCheck(){

		// create a list of days to display to the user
		// date time 0 index is Sunday
		var Days = [
			"Sunday",
			"Monday",
			"Tuesday",
			"Wednesday",
			"Thursday",
			"Friday",
			"Saturday"
		]; 

		// List of months
		var Months = [ 
			"January",
			"February",
			"March",
			"April",
			"May",
			"June",
			"July",
			"August",
			"September",
			"October",
			"November",
			"December"
		];

		// Generate a new data
		var d = new Date();

		// Get the hour of the day and detirmine AM or PM then change to 12 hour clock
		var hours = d.getHours();
		var ampm  = "am"
		if( hours > 12 ){
			hours -= 12; 
			ampm   = "pm";
		}

		// get the minutes and make sure it is displayed a 2 digit value
		var minutes = d.getMinutes();
		if( minutes < 10 ) minutes = "0"+minutes;

		// get the seconds and make sure it is displayed as a 2 digit value
		var seconds = d.getSeconds();
		if( seconds < 10 ) seconds = "0"+seconds;

		// we want the separator to blink at a regular interval to show it is working
		separatorText.opacity = seconds % 2;

		// set the number of hours to display
		hourText.text = ""+hours;
		// set the number of minutes to display
		minuteText.text = minutes + " " + ampm;

		// Now get the date information
		var dayOfWeek = d.getDay();
		var day = d.getDate();
		var month = d.getMonth();
		var year = d.getFullYear();

		// format the date time in a nice format Day, # Month ####
		dateText.text = Days[dayOfWeek] + ", " + day + " " + Months[month] + " " + year;

		// choose the moon icon based on the calculated moonphase algorithm
		var moonIcon = IconMap.moonmap[moonphase(d)];
		// set the icon
		moonPhaseIcon.source = "source/weather_icons/weather-icons-master/svg/wi-"+moonIcon+".svg";
	}

	/** Calculateds the moonphase for the given date
	 * https://www.subsystems.us/uploads/9/8/9/4/98948044/moonphase.pdf
	 * @param date Date object to get date for moon algorithm
	 * @return int day in the moonphase cycle from 1 to ~28
	 */
	function moonphase( date ){
		var Y = date.getFullYear();
		var D = date.getDate();
		var M = date.getMonth();

		if( M <= 2 ){
			Y-=1;
			M+=12;
		}

		var A = parseInt(Math.floor(Y/100));
		var B = parseInt(Math.floor(A/4));
		var C = 2-A+B;
		var E = parseInt(Math.floor(365.25 * (Y+4716)));
		var F = parseInt(Math.floor(30.6001 * (M+1)));
		var JD = C+D+E+F-1524.5;

		var daySince = JD - 2451549.5;
		var newMoon = daySince / 29.53;

		var percent = newMoon - parseInt(Math.floor(newMoon));

		return parseInt(Math.floor(percent*28));
	}

	/** Use shadow text component to display the hours */
	ShadowText {
		id: hourText
		text: "8"

		// anchored to the left side of the screen
		//anchors.left: parent.left
		// the components bottom aligns with the top of the date field
		anchors.bottom: dateText.top

		// use large font and bold face
		font.pointSize: textEmph
		font.bold: true

		// use the specified color
		color: fontColor	
	}

	/** The separator blinks to show time is working */
	ShadowText {
		id: separatorText

		// default separator value
		text: ":"

		// left side aligns tot he right of the hours
		anchors.left: hourText.right
		// its bottom aligns to the top of the date
		anchors.bottom: hourText.bottom

		// large, bold, and white
		font.pointSize: textEmph
		font.bold: true
		color: fontColor	
	}

	/** Shadowed text module for the minutes */
	ShadowText {
		id: minuteText
		text: "30 am"

		// left side against he right side of the separator
		anchors.left: separatorText.right
		// bottom against the top of the date
		anchors.bottom: hourText.bottom

		// large, bold, and white
		font.pointSize: textEmph
		font.bold: true
		color: fontColor	
	}

	/** Display the date in a nice format */
	ShadowText {
		id: dateText
		text: "Sunday, 29 March, 2020"

		// anchored against the left edge of the screen
		// anchors.left: parent.left
		// anchored with its bottom against the bottom of the screen
		anchors.bottom: parent.bottom

		// regular font, white
		font.pointSize: textSize
		color: fontColor
	}

	/** Display the moon icon */
	ShadowIcon {
		id: moonPhaseIcon

		// anchor the left edge to the right of the date
		anchors.left: dateText.right
		// and the bottom edge to the bottom of the screen
		anchors.bottom: dateText.bottom

		// set the size as a square that matches the date's height
		height: dateText.height
		width: height

		// add a little space to the left between date and icon
		anchors.leftMargin: 10
	}
	
}
