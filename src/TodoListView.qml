import QtQuick 2.0

Item {
    id: root

    function insertItem(item){
        for(var i=0; i<listmodel.count; ++i){
            if(listmodel.get(i).iPri > item.pri){
                listmodel.insert(i, {'iText': item.text,
                                     'iPri': item.pri,
                                     'iDone': item.done,
                                     'iColor': addview.getColor(item.pri) });
                return;
            }
        }

        //not found
        listmodel.append({'iText': item.text,
                             'iPri': item.pri,
                             'iDone': item.done,
                             'iColor': addview.getColor(item.pri) });
    }

    function saveItems(){
        var l = [];
        for(var i=0; i<listmodel.count; ++i){
            l.push({'pri': listmodel.get(i).iPri,
                       'text': listmodel.get(i).iText,
                       'done': listmodel.get(i).iDone });
        }

        eventscpp.saveItems(l);
    }

    function changePri(index, newPri){
        list.currentIndex = -1;
        listmodel.setProperty(index, 'iDone', false);
        listmodel.setProperty(index, 'iPri', newPri);
        listmodel.setProperty(index, 'iColor', addview.priColorMap[newPri]);

        var moved = false;
        for(var i=0; i < listmodel.count; ++i){
            if(i != index &&
                    listmodel.get(i).iPri > newPri){
                if(index > i)
                    listmodel.move(index, i, 1);
                else
                    listmodel.move(index, i - 1, 1);
                moved = true;
                break;
            }
        }

        if(!moved)
            listmodel.move(index, listmodel.count - 1, 1);

        root.saveItems();
    }

    clip: true

    ListView {
        id: list
        anchors.fill: parent


        clip: true
        model: ListModel {
            id: listmodel
        }

        delegate: Component {
            Item {
                id: wrapper
                width: list.width
                height: 120

                Row {
                    id: actionBar
                    anchors.centerIn: parent

                    spacing: (parent.width - 100 * 6) / 7

                    ActionButton {
                        text: "1"
                        onClicked: {
                            root.changePri(index, 1);
                        }
                    }
                    ActionButton {
                        text: "3"
                        onClicked: {
                            root.changePri(index, 3);
                        }
                    }
                    ActionButton {
                        text: "5"
                        onClicked: {
                            root.changePri(index, 5);
                        }
                    }
                    ActionButton {
                        icon: "assets/timer.png"
                        onClicked: {
                            root.changePri(index, 99);
                        }
                    }
                    ActionButton {
                        visible: iDone
                        icon: "assets/reset.png"
                        onClicked: {
                            list.currentIndex = -1;
                            listmodel.setProperty(index, "iDone", false);
                            root.saveItems();
                        }
                    }
                    ActionButton {
                        visible: !iDone
                        icon: "assets/flag.png"
                        onClicked: {
                            list.currentIndex = -1;
                            listmodel.setProperty(index, "iDone", true);
                            root.saveItems();
                        }
                    }
                    ActionButton {
                        icon: "assets/trash.png"
                        onClicked: {
                            list.currentIndex = -1;
                            listmodel.remove(index);
                            root.saveItems();
                        }
                    }
                }

                Item {
                    id: contentRow
                    x: 0
                    width: parent.width
                    height: parent.height
                    Row {
                        anchors.fill: parent
                        Rectangle {
                            id: colorRect
                            width: 15
                            height: parent.height
                            color: iColor
                        }

                        Rectangle {
                            width: parent.width - colorRect.width
                            height: parent.height
                            color:  contentMouse.realPressed? "#8FE2D2": "#ECF0F1"
                            Text {
                                id: txt
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                height: parent.height - 60
                                text: iText
                                fontSizeMode: Text.Fit
                                font.pointSize: 50
                                color: iPri == 99 || iDone? "grey" : "#4E6061"
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                font.strikeout: iDone
                            }
                        }
                    }


                    MouseArea {
                        id: contentMouse
                        anchors.fill: parent
                        property bool realPressed: false
                        onPressAndHold: {
                            realPressed = false;
                            list.currentIndex = index;
                        }

                        onPressed: {
                            pressedTimer.restart();
                        }
                        onReleased: {
                            pressedTimer.stop();
                            realPressed = false;
                        }

                        onCanceled: {
                            pressedTimer.stop();
                            realPressed = false;
                        }

                        Timer {
                            id: pressedTimer
                            repeat: false
                            interval: 100
                            onTriggered: contentMouse.realPressed = true
                        }
                    }
                }

                Line {
                    anchors {
                        left: parent.left; leftMargin: 15
                        right: parent.right
                        bottom: parent.bottom
                    }
                }


                state: ""
                states: [
                    State {
                        name: "showAction"
                        when: list.currentIndex == index
                        PropertyChanges {
                            target: contentRow
                            x: contentRow.width
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: "*"
                        to: "*"

                        ParallelAnimation {
                            id: actionShowAnim
                            NumberAnimation {
                                target: contentRow
                                property: "x"
                                duration: 200
                            }
                        }
                    }
                ]

            }

        }

        move: Transition {
            NumberAnimation {
                property: "y"
                duration: 500
            }
        }

        remove: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; to: 0; duration: 500 }
                NumberAnimation { property: "x"; from: 0; to: root.width; duration: 500 }
            }
        }

        add: Transition {
            NumberAnimation {
                property: "y"
                from: 0
                duration: 500
            }
        }

        displaced: Transition {
            NumberAnimation {
                property: "y"
                duration: 500
            }
        }

        currentIndex: -1
        onDragStarted: {
            currentIndex = -1;
        }
    }
}
