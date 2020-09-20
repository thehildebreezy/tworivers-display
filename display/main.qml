/**
 * Main.qml
 * tworivers-display
 * Defines the main window, provides the slot/signal interfaces for interaction between the python
 * controller and the QML view
 * @author Tanner Hildebrand
 * @version 1.0
 */
import QtQuick 2.0

/** Our main display will be a rectangle */
Rectangle {
	id: page

	// 800x480 hard coded in to match the resolution of my Raspberry Pi 7inch touch screen
	width:800; height: 480
	color: "black"


	/* SLOTS */

	/**
	 * This slot is invoked by the controller when the slideshow can be updated with new images
	 * @param data string JSON data containing paths to images for slideshow
	 */
	function ssUpdate( data ){
		console.log("Slide show update slot received");
		// load new images into the Slideshow component
		slides.loadImgs( data );
	}

	/**
	 * This slot is invoked by the controller when the current weather can be updated with new
	 * weather data
	 * @param data string JSOn string with weather data from OWM format
	 */
	function currentUpdate( data ){
		weather.currentUpdate( data );
	}

	/**
	 * This slot is invoked by the controller when the forecast weather can be updated with new
	 * forecast data
	 * @param data string JSOn string with forecast data from OWM format
	 */
	function forecastUpdate( data ){
		weather.forecastUpdate( data );
	}

	/**
	 * This slot is invoked by the controller when the controller toggles brightness
	 * @param data string information on the brightness toggle from the controller
	 */
	function toggleBrightness(data){
		console.log(data);
	}



	/* LOCAL METHODS */

	/**
	 * This method is called by the timer when it detirmines enough time has passed taht
	 * it should update its own data pool
	 */
	function requestRefresh(){
		console.log("View requesting refresh");

		// The manager object is injected from Python
		// it is a reference to the RequestManager class and can be used to request information from
		// the Controller/Model
		manager.requestRefresh();
	}

	/** 
	 * This method is called when the screen is touched to request the controller to toggle 
	 * brightness of the backlight
	 */
	function requestToggleBrightness(){
		console.log("View requesting brightness toggle");
		manager.requestToggleBrightness();
	}

	/** Timer waits */
	Timer  {
		id: refreshTimer
		interval: 900000 // in ms, 900000 = 15 min
		repeat: true	 // keep repeating
		running: true
		onTriggered: requestRefresh()
	}


	// invoke the slideshow module to run in the background
	Slideshow {
		id: slides
		height: parent.height		// fill parent height
		width: parent.width			// file parent width
		anchors.left: parent.left	// anchor to parent bounds
		anchors.top: parent.top

		// Click mousearea to request brightness toggle
		MouseArea {
			// fill the entire area
			anchors.fill: parent
			onClicked: { requestToggleBrightness(); }
		}

	}

	// Invoke the datetime component and put it in the bottom left
	Datetime {
		id: dt
		anchors.left: parent.left		// left side of screen
		anchors.bottom: parent.bottom	// bottom of screen
		anchors.leftMargin: 20
		anchors.bottomMargin: 20
	}

	// invoke the weather component and put i tin the bottomright
	Weather {
		id: weather
		anchors.right: parent.right		// right side of screen
		anchors.bottom: parent.bottom	// bottom of screen
		anchors.rightMargin: 20
		anchors.bottomMargin: 20
	}

	// lights out application
	/*LightsOut {
		anchors.fill: parent
	}*/
}
