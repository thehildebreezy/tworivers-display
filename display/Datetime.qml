import QtQuick 2.0
import QtGraphicalEffects 1.0
import "source/weather_icons/weather-icons-master/iconmap.js" as IconMap

Item {
	property int textSize: 18
	property int textEmph: 24
	property string fontColor: "white"

	Timer  {
		id: clockTimer
		interval: 500
		repeat: true
		running: true
		onTriggered: startTimeCheck()
	}

	function startTimeCheck(){

		var Days = [
			"Monday",
			"Tuesday",
			"Wednesday",
			"Thursday",
			"Friday",
			"Saturday",
			"Sunday"
		];

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

		var d = new Date();
		var hours = d.getHours();
		var ampm  = "am"
		if( hours > 12 ){
			hours -= 12;
			ampm   = "pm";
		}
		var minutes = d.getMinutes();
		if( minutes < 10 ) minutes = "0"+minutes;
		var seconds = d.getSeconds();
		if( seconds < 10 ) seconds = "0"+seconds;

		separatorText.opacity = seconds % 2;
		hourText.text = ""+hours;
		minuteText.text = minutes + " " + ampm;

		var dayOfWeek = d.getDay();
		var day = d.getDate();
		var month = d.getMonth();
		var year = d.getFullYear();

		dateText.text = Days[dayOfWeek] + ", " + day + " " + Months[month] + " " + year;

		var moonIcon = IconMap.moonmap[moonphase(d)];
		moonPhaseIcon.source = "source/weather_icons/weather-icons-master/svg/wi-"+moonIcon+".svg";
	}

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

	ShadowText {
		id: hourText
		text: "8"
		anchors.left: parent.left
		anchors.bottom: dateText.top

		font.pointSize: textEmph
		font.bold: true

		color: fontColor	
	}

	ShadowText {
		id: separatorText
		text: ":"
		anchors.left: hourText.right
		anchors.bottom: dateText.top

		font.pointSize: textEmph
		font.bold: true

		color: fontColor	
	}
	ShadowText {
		id: minuteText
		text: "30 am"
		anchors.left: separatorText.right
		anchors.bottom: dateText.top

		font.pointSize: textEmph
		font.bold: true

		color: fontColor	
	}


	ShadowText {
		id: dateText
		text: "Sunday, 29 March, 2020"
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		font.pointSize: textSize

		color: fontColor
	}

	ShadowIcon {
		id: moonPhaseIcon
		anchors.left: dateText.right
		anchors.bottom: dateText.bottom
		height: dateText.height
		width: height
		anchors.leftMargin: 10
	}
	
}
