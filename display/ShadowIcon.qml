import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    property alias source: icon.source

	Image {
		id: icon
		anchors.fill: parent

		ColorOverlay {
			anchors.fill: parent
			source: parent
			color: "white"
		}   
	}
	
	DropShadow {
		anchors.fill: icon
		source: icon
		verticalOffset: 2
		color: "black"
		radius: 1
		samples: 3
	}
}