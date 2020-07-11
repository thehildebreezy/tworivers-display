import QtQuick 2.0
import "source/weather_icons/weather-icons-master/iconmap.js" as IconMap

Item {
	property int textSize: 18
	property int textEmph: 24
	property int textSizeOther: 16

	function forecastUpdate( data ){
		console.log("Forecast weather slot received");

		var response = JSON.parse( data );
		if( !response ){
			failed = true;
			return;
		}

		var Days = [
			'M','T','W','T','F','S','S'
		];

		var d = new Date( response['list'][0]['dt_txt'] );
		d.setHours(0);

		var today = d.getDay();

		// now find the first item that beats this date+1
		var i=0;
		var nextDayIndex = 0;
		for( i=0; i<40; i++ ){
			var next = new Date( response['list'][i]['dt_txt'] );
			next.setHours(0);
			if(next > d){
				nextDayIndex = i;
				break;
			}
		}

		// select middle of the day
		var objOne = response['list'][nextDayIndex+4];
		var objTwo = response['list'][nextDayIndex+12];
		var objThree = response['list'][nextDayIndex+20];

		// set all the appropriate sources
		var icidOne = "wi-owm-" + objOne["weather"][0]["id"];
		var icOne = IconMap.mapping[icidOne];
		iconOne.source = "source/weather_icons/weather-icons-master/svg/wi-"+icOne+".svg";
		tempOne.text = k_to_f(objOne["main"]["temp"])+"\xB0F";
		dayOne.text = Days[((today+0)%7)];

		
		var icidTwo = "wi-owm-" + objTwo["weather"][0]["id"];
		var icTwo = IconMap.mapping[icidTwo];
		iconTwo.source = "source/weather_icons/weather-icons-master/svg/wi-"+icTwo+".svg";
		tempTwo.text = k_to_f(objTwo["main"]["temp"])+"\xB0F";
		dayTwo.text = Days[((today+1)%7)];

		
		var icidThree= "wi-owm-" + objThree["weather"][0]["id"];
		var icThree = IconMap.mapping[icidThree];
		iconThree.source = "source/weather_icons/weather-icons-master/svg/wi-"+icThree+".svg";
		tempThree.text = k_to_f(objThree["main"]["temp"])+"\xB0F";
		dayThree.text = Days[((today+2)%7)];
	}

	function currentUpdate( data ){
		console.log("Current weather slot received.");
		
		var response = JSON.parse( data );
		if( !response ) {
			failed = true;
			return;
		}

		var iconid = "wi-owm-" + response["weather"][0]["id"];
		var icon = IconMap.mapping[iconid];
		weatherIcon.source = "source/weather_icons/weather-icons-master/svg/wi-"+icon+".svg";
		temp.text = k_to_f(response["main"]["temp"])+"\xB0F";
		desc.text = response["name"] + " / " + response["weather"][0]["description"];
	}

	function k_to_f(K){
		var C = K-273.15;
		var F = (9 * (C/5)) + 32;
		return Math.floor(parseInt(F));
	}


	Grid {
		id: forecast
		rows: 3; columns: 3
		anchors.right: parent.right
		anchors.bottom: temp.top
		anchors.bottomMargin: 4
		spacing: 10

		ShadowText {
			id: dayOne
			text: "M:"
			font.pointSize: textSizeOther
			color: "white"
		}
		ShadowIcon {
			id: iconOne
			height: dayOne.height
			width: height
		}
		ShadowText {
			id: tempOne
			text: "\xB0"
			font.pointSize: textSizeOther
			color: "white"
		}
		ShadowText {
			id: dayTwo
			text: "T:"
			font.pointSize: textSizeOther
			color: "white"
		}
		ShadowIcon {
			id: iconTwo
			height: dayTwo.height
			width: height
		}
		ShadowText {
			id: tempTwo
			text: "\xB0"
			font.pointSize: textSizeOther
			color: "white"
		}
		ShadowText {
			id: dayThree
			text: "W:"
			font.pointSize: textSizeOther
			color: "white"
		}
		ShadowIcon {
			id: iconThree
			height: dayThree.height
			width: height
		}
		ShadowText {
			id: tempThree
			text: "\xB0"
			font.pointSize: textSizeOther
			color: "white"
		}
	}

	ShadowText {
		id: temp
		text: "72\xB0F"
		anchors.right: parent.right
		anchors.bottom: desc.top
		font.pointSize: textEmph
		font.bold: true
		color: "white"
	}

	ShadowIcon {
		id: weatherIcon
		source: "source/weather_icons/weather-icons-master/svg/wi-cloudy.svg"
		height: temp.height
		width: height
		anchors.right: temp.left
		anchors.bottom: temp.bottom
		anchors.rightMargin: 10
	}

	ShadowText {
		id: desc
		text: "Cloudy"
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		font.pointSize: textSize
		color: "white"
	}
}
