import QtQuick 2.0

Rectangle {
	id: page
	width:800; height: 480
	color: "lightgrey"

	function ssUpdate( data ){
		console.log("Slide show update slot received");
		slides.loadImgs( data );
	}

	function currentUpdate( data ){
		weather.currentUpdate( data );
	}
	function forecastUpdate( data ){
		weather.forecastUpdate( data );
	}
	function toggleBrightness(data){
		console.log(data);
	}

	function requestRefresh(){
		console.log("View requesting refresh");
		manager.requestRefresh();
	}

	function requestToggleBrightness(){
		console.log("View requesting brightness toggle");
		manager.requestToggleBrightness();
	}


	Timer  {
		id: refreshTimer
		interval: 1800000
		repeat: true
		running: true
		onTriggered: requestRefresh()
	}

	Slideshow {
		id: slides
		height: parent.height
		width: parent.width
		anchors.left: parent.left
		anchors.top: parent.top

		// Click mousearea to request brightness toggle
		MouseArea {
			anchors.fill: parent
			onClicked: { requestToggleBrightness(); }
		}

	}

	
	Datetime {
		id: dt
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.leftMargin: 20
		anchors.bottomMargin: 20
	}

	Weather {
		id: weather
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.rightMargin: 20
		anchors.bottomMargin: 20
	}
}
