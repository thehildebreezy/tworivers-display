import QtQuick 2.0

Item {
	property int speed: 10000
	property int changeover: 1000

	property int index: 0
	property var imgs: null
	
	property int currentImg: 1

	Timer {
		id: slideTimer
		running: false
		repeat: true
		interval: speed
		onTriggered: rotateSlides()
	}

	function getRandomInt(max) {
		return Math.floor(Math.random() * Math.floor(max));
	}

	function rotateSlides() {
		console.log("rotating slides");
		slideTimer.running = false;
		if( currentImg == 1 ){
			nextImage(imgTwo);
			currentImg = 2;
		} else {
			nextImage(imgOne);
			currentImg = 1;
		}
	}

	function imageOneReady(){
		console.log("image one ready");
		imgOne.opacity = 0;
		imgOne.z = 2;
		imgTwo.z = 1;
		imgOneAnimation.start();
		slideTimer.running=true;
	}

	function imageTwoReady(){
		console.log("image two ready");
		imgTwo.opacity = 0;
		imgTwo.z = 2;
		imgOne.z = 1;
		imgTwoAnimation.start();
		slideTimer.running=true;
	}

	Image {
		id: imgOne
		height: parent.height
		width: parent.width
		opacity: 0
		fillMode: Image.PreserveAspectCrop

		onStatusChanged: {
			if (imgOne.status == Image.Ready) imageOneReady();
		}

		NumberAnimation on opacity {
			id: imgOneAnimation
			from: 0
			to: 1
			duration: changeover

		}

		z: 1
	}

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

	function loadImgs( data ){

		slideTimer.running = false

		var failed = false;

		imgs = JSON.parse( data );
		if( !imgs ) {
			failed = true;
			return;
		}
		
		nextImage( imgOne );
		slideTimer.running = true
	}

	function nextImage( imgComponent ){
		if( !imgs ) return;
		
		if( index >= imgs.photos.length-1 ) index = 0;
		
		//var path = imgs.photos[index++];
		var rand = getRandomInt(imgs.photos.length-1);
		var path = imgs.photos[rand];
		if( path == imgComponent.source ){
			if( rand == 0 ){
				rand = 1;
			} else {
				rand -= 1;
			}
			path = imgs.photos[rand];
		}

		console.log("Displaying image: " + path);
		imgComponent.source = path;
		
	}


	function loadSlide(i){

	}
}
