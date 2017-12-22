import QtQuick 2.0

Rectangle {
    id: titlebar
    width: parent.width
    height: 100
    color: "#f2f2ee"

    property int pageIndex: 0

    state: "default"

    Text {
        anchors.centerIn: parent
        text: qsTr("135 TODO")
        font.pointSize: 20
        color: "#929292"
    }

    ActionButton {
        anchors {
            left: parent.left; leftMargin: 20
            verticalCenter: parent.verticalCenter
        }

        visible: titlebar.state == "adding"
        icon: "assets/reverse_arrow.png"
        onClicked: titlebar.state = "default"
    }

    ActionButton {
        anchors {
            right: parent.right; rightMargin: 20
            verticalCenter: parent.verticalCenter
        }

        visible: titlebar.state == "default"
        icon: "assets/new.png"
        onClicked: titlebar.state = "adding"
    }

    Line {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}