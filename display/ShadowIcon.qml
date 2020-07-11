/**
 * ShadowText.qml
 * Adds a nice drop shadow effect to an icon
 * @author Tanner Hildebrand
 * @version 1.0
 */
import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

	// forwards the source property to the icon
    property alias source: icon.source

	Image {
		id: icon

		// the icons size will match what is specified as a size fot he parent
		anchors.fill: parent

		// set the icon color to white
		// could also create a property/alias for this to specify externally
		ColorOverlay {
			anchors.fill: parent
			source: parent
			color: "white"
		}   
	}
	
	// add a nice, standardized size, drop shadow to the icon
	DropShadow {
		anchors.fill: icon
		source: icon
		verticalOffset: 2
		color: "black"
		radius: 1
		samples: 3
	}
}