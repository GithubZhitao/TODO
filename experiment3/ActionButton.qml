import QtQuick 2.0

Rectangle {
    id: root
    width: 100
    height: 100

    property alias text: txt.text
    property alias icon: img.source
    signal clicked();

    color: mouse.pressed? "#8FE2D2" : "transparent"


    Image {
        id: img
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: txt
        anchors.fill: parent
        anchors.margins: 8
        color: "#929292"
        font.pointSize: 50
        fontSizeMode: Text.Fit
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
    }
}