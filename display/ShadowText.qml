/**
 * ShadowText.qml
 * Adds a nice drop shadow effect to text
 * @author Tanner Hildebrand
 * @version 1.0
 */
import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
	// forward all Component properties to the Text object
	property alias text: textBlock.text
	property alias color: textBlock.color
	property alias font: textBlock.font
	
	// this Components size will appear (to the invoking Component)
	// to match the size of its child text element
	height: textBlock.height
	width: textBlock.width

	// the basic text building block
	// properties ill match the alias properties defined above
	Text {
		id: textBlock
	}
	
	// add the dropshadow effect to the text in a standard manner
	DropShadow {
		anchors.fill: textBlock
		source: textBlock
		verticalOffset: 2
		color: "black"
		radius: 2
		samples: 3
	}
}
