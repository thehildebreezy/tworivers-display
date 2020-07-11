/**
 * Weather.qml
 * tworivers-display
 * Defines the weather display component; shows current weather, 3 day forecast, location and status
 * @author Tanner Hildebrand
 * @version 1.0
 */
import QtQuick 2.0
import "source/weather_icons/weather-icons-master/iconmap.js" as IconMap

/** Base item, invoked as a Weather component */
Item {
	/** Default text size */
	property int textSize: 18
	/** Large emphasis text size */
	property int textEmph: 24
	/** Small text size */
	property int textSizeOther: 16

	/** 
	 * Handles receiving updated forecast data from the controller
	 * @param data JSON string containing forecast information
	 */
	function forecastUpdate( data ){
		console.log("Forecast weather slot received");

		// parse the JSON string and fail if bad format
		var response = JSON.parse( data );
		if( !response ){
			failed = true;
			return;
		}

		// create a cheat sheet for looking up days of the week
		var Days = [
			'S','M','T','W','T','F','S'
		];

		// Generate an idea of what day it is from the first listed
		// date time text group from the OWM response
		var d = new Date( response['list'][0]['dt_txt'] );
		d.setHours(0); // reset to 0 hours (in case middle of the day)

		// figure out what day is first listed (should be today)
		var today = d.getDay();

		// now find the first item in the forecast that beats this day; i.e, date+1
		var i=0;
		var nextDayIndex = 0;
		for( i=0; i<40; i++ ){
			var next = new Date( response['list'][i]['dt_txt'] );
			next.setHours(0);     // reset day to 0 hours like we did to the base date
			if(next > d){         // found day > today
				nextDayIndex = i; 
				break;
			}
		}

		// select middle of the day
		// responses are sent in 3 hour blocks
		// So to get to noon from midnight, add 4 indexes (4*3 = 12)
		// to get one day after that, add 8 (8*3 = 24)
		var objOne = response['list'][nextDayIndex+4];
		var objTwo = response['list'][nextDayIndex+12];
		var objThree = response['list'][nextDayIndex+20];

		// We've pre generated a mapping from the ID to the icon svg name and included it above
		// just translate the icon ID to the nomenclature and set the source
		var icidOne = "wi-owm-" + objOne["weather"][0]["id"];
		var icOne = IconMap.mapping[icidOne];
		iconOne.source = "source/weather_icons/weather-icons-master/svg/wi-"+icOne+".svg";

		// I'm hard coding Farenheit here - by default temperature is in kelvin, so convert and add degF
		tempOne.text = k_to_f(objOne["main"]["temp"])+"\xB0F";

		// Choose the day using the Days[] cheat sheet defined above
		dayOne.text = Days[((today+0)%7)];

		// Repeat the above process for each of our other two forecast slots
		var icidTwo = "wi-owm-" + objTwo["weather"][0]["id"];
		var icTwo = IconMap.mapping[icidTwo];
		iconTwo.source = "source/weather_icons/weather-icons-master/svg/wi-"+icTwo+".svg";
		tempTwo.text = k_to_f(objTwo["main"]["temp"])+"\xB0F";
		dayTwo.text = Days[((today+1)%7)];

		// Repeat for the final forecast slot
		var icidThree= "wi-owm-" + objThree["weather"][0]["id"];
		var icThree = IconMap.mapping[icidThree];
		iconThree.source = "source/weather_icons/weather-icons-master/svg/wi-"+icThree+".svg";
		tempThree.text = k_to_f(objThree["main"]["temp"])+"\xB0F";
		dayThree.text = Days[((today+2)%7)];
	}

	/** 
	 * Handle an update to the current weather being passed from the controller
	 * and update the display accordingly
	 * @param data string JSON data from OWM format
	 */
	function currentUpdate( data ){
		console.log("Current weather slot received.");
		
		// parse JSON string and fail if bad data
		var response = JSON.parse( data );
		if( !response ) {
			failed = true;
			return;
		}

		// Set the Icon for conditions fromt he OWM ID definition, using mapping predefined included above
		var iconid = "wi-owm-" + response["weather"][0]["id"];
		var icon = IconMap.mapping[iconid];
		weatherIcon.source = "source/weather_icons/weather-icons-master/svg/wi-"+icon+".svg";

		// hard coding Farenheit values, converted from Kelvin using the simple formula below
		temp.text = k_to_f(response["main"]["temp"])+"\xB0F";

		// sets the display for the location and text based status
		desc.text = response["name"] + " / " + response["weather"][0]["description"];
	}

	/** Converts Kelvin to Farenheit using standard formulas 
	 *	@param K double value of the temperature in Kelvin
	 *  @return int integer value of the Farenheit represenation of the temperature
	 */
	function k_to_f(K){
		var C = K-273.15;
		var F = (9 * (C/5)) + 32;
		return Math.floor(parseInt(F));
	}

	/**
	 * This Grid holds the forecast information diaplay
	 * It creates a 3x3 table with row format: Day Initial | Weather Icon | Temperature
	 * it is all hard coded instead of procedurally generated since it is static and small
	 */
	Grid {
		id: forecast
		rows: 3; columns: 3			// 3x3 table
		anchors.right: parent.right // anchor tot right side of screen
		anchors.bottom: temp.top	// the bottom of the forecast on top of the current weather
		anchors.bottomMargin: 4		// a little bit of space between current and forecast
		spacing: 10					// 10px between each cell

		/** Day 1 (Today+1) initial */
		ShadowText {
			id: dayOne
			text: "M:"
			font.pointSize: textSizeOther
			color: "white"
		}
		/** Day 1 (Today+1) weather icon */
		ShadowIcon {
			id: iconOne
			height: dayOne.height
			width: height
		}
		/** Day 1 (Today+1) temperature */
		ShadowText {
			id: tempOne
			text: "\xB0"
			font.pointSize: textSizeOther
			color: "white"
		}
		/** Day 2 (Today+2) initial */
		ShadowText {
			id: dayTwo
			text: "T:"
			font.pointSize: textSizeOther
			color: "white"
		}
		/** Day 2 (Today+2) weather icon */
		ShadowIcon {
			id: iconTwo
			height: dayTwo.height
			width: height
		}
		/** Day 3 (Today+3) temperature */
		ShadowText {
			id: tempTwo
			text: "\xB0"
			font.pointSize: textSizeOther
			color: "white"
		}
		/** Day 3 (Today+3) initial */
		ShadowText {
			id: dayThree
			text: "W:"
			font.pointSize: textSizeOther
			color: "white"
		}
		/** Day 3 (Today+3) weather icon */
		ShadowIcon {
			id: iconThree
			height: dayThree.height
			width: height
		}
		/** Day 3 (Today+3) temperature */
		ShadowText {
			id: tempThree
			text: "\xB0"
			font.pointSize: textSizeOther
			color: "white"
		}
	}

	/** 
	 * Displays the temperature for the current weather
	 */
	ShadowText {
		id: temp
		text: "72\xB0F"
		anchors.right: parent.right // anchors to the right side of the screen
		anchors.bottom: desc.top	// bottom sits on top of the location/weather description
		font.pointSize: textEmph	// font size is large
		font.bold: true				// font is bold
		color: "white"				// default color is white
	}

	/** Displays the current weather icon */
	ShadowIcon {
		id: weatherIcon
		height: temp.height			// height matches the temperatures height
		width: height				// make it square
		anchors.right: temp.left	// the right side of the icon sits against the left side of the temp
		anchors.bottom: temp.bottom // its bottom lines up with temperatures bottom
		anchors.rightMargin: 10		// 
	}

	ShadowText {
		id: desc
		text: "Cloudy"
		anchors.right: parent.right		// anchors on the right of the screen
		anchors.bottom: parent.bottom	// anchors on the bottom of the screen
		font.pointSize: textSize
		color: "white"
	}
}
