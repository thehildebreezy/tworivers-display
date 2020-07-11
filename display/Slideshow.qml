/**
 * Slideshow.qml
 * tworivers-display
 * Plays a slideshow of photos in the background loaded from a remote storage source
 * @author Tanner Hildebrand
 * @version 1.0
 */
import QtQuick 2.0

Item {
	/** Interval at which to change photos */
	property int speed: 10000 	  // 10 seconds
	/** Speed at which the photo fades away */
	property int changeover: 1000 // 1 second

	/** Keep track of the photo index, in case we switch back to sequential */
	property int index: 0

	/** Keep track of the available image paths in memory */
	property var imgs: null
	
	/** Keep track of which image component is currently displaying our slide */
	property int currentImg: 1

	/** Timer triggers every time a new photo should be laoded */
	Timer {
		id: slideTimer
		running: false
		repeat: true
		interval: speed
		onTriggered: rotateSlides() // call rotate slide to get anew slide
	}

	/** Generate a random integer from 0 to max -1
	 *  @param max int maximum value for a random integer
	 */
	function getRandomInt(max) {
		return Math.floor(Math.random() * Math.floor(max));
	}

	/**
	 * Triggered by the slideTimer in order to initiate a slide rotation
	 * Chooses which image component should host the new image
	 */
	function rotateSlides() {
		console.log("rotating slides");
		slideTimer.running = false;
		if( currentImg == 1 ){	// if image 1 holds it
			nextImage(imgTwo);  // load in to 2
			currentImg = 2;
		} else {
			nextImage(imgOne);  // and vice versa
			currentImg = 1;
		}
	}

	/** 
	 * Function triggered when imageOne has completely loaded its slide
	 * Once loaded (behind the other image) sets itself invisible, moves the front
	 * then fades itself in
	 */
	function imageOneReady(){
		console.log("image one ready");
		imgOne.opacity = 0;
		imgOne.z = 2;
		imgTwo.z = 1;
		imgOneAnimation.start();
		slideTimer.running=true;	// restart the paused slide timer
	}

	/** 
	 * Function triggered when imageTwo has completely loaded its slide
	 * Once loaded (behind the other image) sets itself invisible, moves the front
	 * then fades itself in
	 */
	function imageTwoReady(){
		console.log("image two ready");
		imgTwo.opacity = 0;
		imgTwo.z = 2;
		imgOne.z = 1;
		imgTwoAnimation.start();
		slideTimer.running=true;	// restart the paused slide timer
	}

	/**
	 * The first image container 
	 * Holds an image and performs its own fade in animation and keeps track of its ready state
	 */
	Image {
		id: imgOne
		height: parent.height	// fill parent
		width: parent.width		// fill parent
		opacity: 0				// start invisible

		// the fill mode will set the image to preserve its aspect ration-preventing it from stretching
		// in awkward manners to fill the screen, it will automatically crop itself to fit in as apposed
		// to fitting the longest end and leaving a gap on the margins
		fillMode: Image.PreserveAspectCrop

		// the image will monitor its own status and when it is completely loaded it will trigger
		// the method to display itself
		onStatusChanged: {
			if (imgOne.status == Image.Ready) imageOneReady();
		}

		// the image will also handle its own animation
		// the ready method wil strigger this animation after the image reports loaded
		NumberAnimation on opacity {
			id: imgOneAnimation
			from: 0 // invisible
			to: 1	// fully visible
			duration: changeover	// takes changeover ms long
		}

		z: 1
	}

	/**
	 * The second image container 
	 * Holds an image and performs its own fade in animation and keeps track of its ready state
	 * Behaves identically to imgOne
	 */
	Image {
		id: imgTwo
		height: parent.height
		width: parent.width
		opacity: 0
		fillMode: Image.PreserveAspectCrop

		onStatusChanged: if (imgTwo.status == Image.Ready) imageTwoReady();

		NumberAnimation on opacity {
			id: imgTwoAnimation
			from: 0
			to: 1
			duration: changeover
		}

		z: 2
	}

	/**
	 * This method is invoked from Main.qml when the Main component receives a signal to the
	 * ssUpdate slot. The JSON data containing the paths to the slides wea re to load is passed along
	 * We parse that JSON string and save it to memory to cycle through
	 * @param data string JSON string containing photo paths
	 */
	function loadImgs( data ){

		// when we are updating, we'll pause the slide timer so we don't 
		// try to change slides in the middle of an update
		slideTimer.running = false

		// assume success
		var failed = false;

		// parse the JSON string, fail if bad data
		imgs = JSON.parse( data );
		if( !imgs ) {
			failed = true;
			return;
		}
		
		// if it worked, we'll load the next image
		nextImage( imgOne );

		// slideTimer.running = true // don't need to run this, imgOneReady will trigger it for us
	}

	/**
	 * This method is invoked every time it is time to change photos
	 * It will randomly select a photo from our photolist and tell the specified imgComponent
	 * to load that image.
	 * @param imgComponent Image Component next in line to update a new slide
	 */
	function nextImage( imgComponent ){

		// if no data fail
		if( !imgs ) return;
		// if we are sequential, restart index
		if( index >= imgs.photos.length-1 ) index = 0;
		
		// use the below line to use sequential, non-random slides
		// var path = imgs.photos[index++];

		// use the next two lines to do random slides
		var rand = getRandomInt(imgs.photos.length-1);
		var path = imgs.photos[rand];

		// check and make sure this photo isn't already loaded in the slide
		if( path == imgComponent.source ){
			// if so, load an adjacent photo instead
			if( rand == 0 ){
				rand = 1;
			} else {
				rand -= 1;
			}
			// update path if duplicate
			path = imgs.photos[rand];
		}

		// update the source
		console.log("Displaying image: " + path);
		imgComponent.source = path;
		
	}

}
