import QtQuick 2.0

Item {
    id: root

    signal added(var intent);

    readonly property var priColorMap: {
        1: "#F37570",
                3: '#F6BB6E',
                5: '#2175D5',
                99: '#DEDEDE'
    }

    function getColor(pri){
        switch(pri){
        case 1:
        case 3:
        case 5:
        case 99:
            return root.priColorMap[pri];
        default:
            return root.priColorMap[99];
        }
    }

    function show(){
        state = "show";
    }

    function hide(){
        state = "";
    }

    state: ""
    height: 0
    clip: true

    states: [
        State {
            name: "show"
            PropertyChanges {
                target: root
                height: 250
                focus: true
            }
            PropertyChanges {
                target: input
                focus: true
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "show"
            PropertyAnimation { target: root; property:"height"; duration: 200 }
        },
        Transition {
            from: "show"
            to: ""
            SequentialAnimation {
                ScriptAction {
                    script: {
                        Qt.inputMethod.hide();
                    }
                }
                PropertyAnimation { target: root; property:"height"; duration: 200 }
            }
        }
    ]


    Column {
        anchors {
            left: parent.left; right: parent.right
        }

        Item {
            width: parent.width
            height: root.height - btnRow.height
            TextInput {
                id: input
                anchors { fill: parent; margins: 10 }
                color: "#4E6061"
                font.pointSize: 24
                wrapMode: TextInput.WrapAtWordBoundaryOrAnywhere
                focus: false
            }
        }

        Row {
            id: btnRow
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            spacing: (parent.width - 100 * 4) / 5
            ActionButton {
                text: "1"
                onClicked: {
                    root.added({'text': input.text, 'pri': 1});
                    input.text = "";
                }
            }
            ActionButton {
                text: "3"
                onClicked: {
                    root.added({'text': input.text, 'pri': 3});
                    input.text = "";
                }
            }
            ActionButton {
                text: "5"
                onClicked: {
                    root.added({'text': input.text, 'pri': 5});
                    input.text = "";
                }
            }
            ActionButton {
                icon: "assets/timer.png"
                onClicked: {
                    root.added({'text': input.text, 'pri': 99});
                    input.text = "";
                }
            }
        }
    }
}