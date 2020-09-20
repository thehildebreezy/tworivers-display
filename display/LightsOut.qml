/**
 * LightsOut.qml
 * tworivers-display
 * Plays a big black clock up
 * @author Tanner Hildebrand
 * @version 1.0
 */
import QtQuick 2.0

Rectangle {

    color: "black"

    Datetime {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        textEmph: 48
        textSize: 32
    }

}
