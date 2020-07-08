import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
	property alias text: textBlock.text
	property alias color: textBlock.color
	property alias font: textBlock.font
	
	height: textBlock.height
	width: textBlock.width

	Text {
		id: textBlock
	}
	
	DropShadow {
		anchors.fill: textBlock
		source: textBlock
		verticalOffset: 2
		color: "black"
		radius: 2
		samples: 3
	}
}
