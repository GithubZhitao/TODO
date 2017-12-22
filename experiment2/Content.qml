/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Extras 1.4
import QtQuick.XmlListModel 2.0


Item {
    id : midContent
    anchors.fill: parent
    property real margin: 8
    property bool addBClicked: false
    signal castMessage(string msg)
    Text {
        id: text
        visible: false
    }

    FontMetrics {
        id: fontMetrics
        font.family: Flat.FlatStyle.fontFamily
    }

    readonly property int layoutSpacing: Math.round(5 * Flat.FlatStyle.scaleFactor)

    property var componentModel: [
        { name: "今日安排", component: eventList },
        { name: "按周显示", component: calendarComponent },
        { name: "紧急事件", component: calendarComponent },
        { name: "今未完成", component: delayButtonComponent },
        { name: "情景", component: dialComponent },
        { name: "月历", component: dialComponent },
        { name: "已过时", component: pieMenuComponent },
        { name: "垃圾箱", component: progressComponent },
        { name: "消息", component: tableViewComponent },
        { name: "帮助", component: textAreaComponent },
        { name: "Tumbler", component: textAreaComponent }
    ]

    Loader {
        id: componentLoader
        anchors.fill: parent
        sourceComponent: addBClicked?inputComponent:componentModel[controlData.componentIndex].component
        //sourceComponent: componentModel[controlData.componentIndex].component
    }

    property Component inputComponent: ScrollView
    {
        id: scrollView
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        Flickable {
            id: flickComp
            anchors.fill: parent
            contentWidth: viewport.width
            contentHeight: inputcolumn.implicitHeight + textMargins * 1.5
            ColumnLayout {
                id: inputcolumn
                anchors.fill: parent
                anchors.margins: textMargins
                spacing: textMargins / 2
                enabled: !settingsData.allDisabled

                GroupBox {
                    title: "事件"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    ColumnLayout {
                        anchors.fill: parent
                        TextField {
                            z: 1
                            placeholderText: "事件主题"
                            Layout.fillWidth: true
                        }
                        TextField {
                            placeholderText: "内容简述"
                           // echoMode: TextInput.Password // TODO: PasswordEchoOnEdit
                            Layout.fillWidth: true
                            height: 2*width
                        }
                    }
                }

                GroupBox {
                    title: "级别"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    visible: Qt.application.supportsMultipleWindows
                    ColumnLayout {
                        anchors.fill: parent
                        ComboBox {
                            editable: true
                            model: ListModel {
                                id: combomodel
                                ListElement { text: "一般" }
                                ListElement { text: "重要" }
                                ListElement { text: "紧急" }
                            }
                            onAccepted: {
                                if (find(currentText) === -1) {
                                    combomodel.append({text: editText})
                                    currentIndex = find(editText)
                                }
                            }
                            Layout.fillWidth: true
                        }
                    }
                }

                GroupBox {
                    title: "日期"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    ColumnLayout {
                        anchors.fill: parent
                       // column: Math.max(1, Math.floor(scrollView.width / inputTime.implicitWidth - 0.5))

                        //====================================    data changed
                        TextField
                        {
                            id: calendarStr
                            property string dateValue

                            Calendar{
                                id: calendar

                                anchors.topMargin: 0
                                anchors.top: parent.bottom
                                visible: false
                                activeFocusOnTab: true
                                onReleased: {
                                    calendarStr.text = date;
                                    calendarStr.text = calendarStr.text.substr(0, 10);
                                    parent.dateValue = calendarStr.text;
                                    visible = false;
                                }
                            }

                            Button{
                                id: downBtn
                                width: 22
                                anchors.right: parent.right
                                anchors.rightMargin: 0
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 0
                                anchors.top: parent.top
                                anchors.topMargin: 0
                             //   iconSource: "../../images/arrow_down.png"
                                onClicked: calendar.visible = !calendar.visible
                            }

                            onDateValueChanged: {
                                calendarStr.text = dateValue;
                                calendar.selectedDate = dateValue;
                            }

                        }

                        //================
                        Item {
                            id : inputTime
                            width: 22
                            anchors.right: parent.right
                            anchors.rightMargin: 0.1*inputTime.width
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            Tumbler {
                                    anchors.centerIn: parent
                                    TumblerColumn {
                                        model: {
                                             var hours = [];
                                             for (var i = 1; i <= 24; ++i)
                                                     hours.push(i < 10 ? "0" + i : i);
                                                     hours;
                                                   }
                                        }
                                    TumblerColumn {
                                       model: {
                                              var minutes = [];
                                              for (var i = 0; i < 60; ++i)
                                                   minutes.push(i < 10 ? "0" + i : i);
                                                   minutes;
                                                   }
                                               }
                                           }
                         }

                        //=================



                    }
                }



                GroupBox{
                  //  title: ""
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    RowLayout{
                        id: buttonLayout
                        anchors.fill: parent

                        // add buttons here  先不用管逻辑了，把功能实现了先
                        Button{
                            id : saveButton
                            text : "保存事件"
                            onClicked: {
                                midContent.addBClicked = false
                            // 获取组件的内容
                           }
                         }

                    Button {
                        id: concelButton
                        text: "取消编辑"
                        onClicked:{
                               midContent.addBClicked = false
                           //恢复到正常的页面
                        }
                    }
                 }

             }
         }
      }

    }

    property Component textComponet: ScrollView {
        id: scrollView
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

        Flickable {
            anchors.fill: parent
            contentWidth: viewport.width
            contentHeight: buttoncolumn.implicitHeight + textMargins * 1.5
            ColumnLayout {
                id: buttoncolumn
                anchors.fill: parent
                anchors.margins: textMargins
                anchors.topMargin: textMargins / 2
                spacing: textMargins / 2
                enabled: !settingsData.allDisabled
                Text{
                 id : myText
                 anchors.fill: parent
                 anchors.margins: 50
                 wrapMode: Text.WordWrap
                 font.family: "Time New Roman"
                 font.pixelSize: 14
                 textFormat: Text.StyledText
                 horizontalAlignment: Text.AlignJustify
                 text: "<p>统计信息<\p> <p>今天啥也没做<\p>"
                 onLineLaidOut: {
                   line.width = parent.width /2 - (margin)
                   if (line.y + line.height >= parent.height ){
                     line.y -= parent.height - margin
                     line.x = parent.width /2 + margin
                   }
                 }
                }
            }
        }
    }
// add new component
    property Component eventList: ScrollView{
        id: scrollView
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff

            ListView {
                id: listView
                anchors.fill: parent

                delegate: SwipeDelegate {
                    id: delegate

                    text: modelData
                    width: parent.width

                    //! [delegate]
                    swipe.right: Rectangle {
                        width: parent.width
                        height: parent.height

                        clip: true
                        color: SwipeDelegate.pressed ? "#555" : "#666"

                        Label {
                            font.family: "Fontello"
                          //  text: delegate.swipe.complete ? "\ue805" // icon-cw-circled
                          //                                : "\ue801" // icon-cancel-circled-1
                            text: delegate.swipe.complete ? "<" // icon-cw-circled
                                                          : "X" // icon-cancel-circled-1
                            padding: 20
                            anchors.fill: parent
                            horizontalAlignment: Qt.AlignRight
                            verticalAlignment: Qt.AlignVCenter

                            opacity: 2 * -delegate.swipe.position

                            color: Material.color(delegate.swipe.complete ? Material.Green : Material.Red, Material.Shade200)
                            Behavior on color { ColorAnimation { } }
                        }

                        Label {
                            text: qsTr("Removed")
                            color: "white"

                            padding: 20
                            anchors.fill: parent
                            horizontalAlignment: Qt.AlignLeft
                            verticalAlignment: Qt.AlignVCenter

                            opacity: delegate.swipe.complete ? 1 : 0
                            Behavior on opacity { NumberAnimation { } }
                        }

                        SwipeDelegate.onClicked: delegate.swipe.close()
                        SwipeDelegate.onPressedChanged: undoTimer.stop()
                    }
                    //! [delegate]

                    //! [removal]
                    Timer {
                        id: undoTimer
                        interval: 3600
                        onTriggered: listModel.remove(index)
                    }

                    swipe.onCompleted: undoTimer.start()
                    //! [removal]
                }

                model: ListModel {
                    id: listModel
                    ListElement { text: "Lorem ipsum dolor sit amet" }
                    ListElement { text: "Curabitur sit amet risus" }
                    ListElement { text: "Suspendisse vehicula nisi" }
                    ListElement { text: "Mauris imperdiet libero" }
                    ListElement { text: "Sed vitae dui aliquet augue" }
                    ListElement { text: "Praesent in elit eu nulla" }
                    ListElement { text: "Etiam vitae magna" }
                    ListElement { text: "Pellentesque eget elit euismod" }
                    ListElement { text: "Nulla at enim porta" }
                    ListElement { text: "Fusce tincidunt odio" }
                    ListElement { text: "Ut non ex a ligula molestie" }
                    ListElement { text: "Nam vitae justo scelerisque" }
                    ListElement { text: "Vestibulum pulvinar tellus" }
                    ListElement { text: "Quisque dignissim leo sed gravida" }
                }

                //! [transitions]
                remove: Transition {
                    SequentialAnimation {
                        PauseAnimation { duration: 125 }
                        NumberAnimation { property: "height"; to: 0; easing.type: Easing.InOutQuad }
                    }
                }

                displaced: Transition {
                    SequentialAnimation {
                        PauseAnimation { duration: 125 }
                        NumberAnimation { property: "y"; easing.type: Easing.InOutQuad }
                    }
                }
                //! [transitions]

                ScrollIndicator.vertical: ScrollIndicator { }
            }

            Label {
                id: placeholder
                text: qsTr("Swipe no more")

                anchors.margins: 60
                anchors.fill: parent

                opacity: 0.5
                visible: listView.count === 0

                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                wrapMode: Label.WordWrap
                font.pixelSize: 18
            }

    }
// add new component
    property Component progressComponent: ScrollView {
        id: scrollView
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        Flickable {
            anchors.fill: parent
            contentWidth: viewport.width
            contentHeight: progresscolumn.implicitHeight + textMargins * 1.5
            ColumnLayout {
                id: progresscolumn
                anchors.fill: parent
                anchors.leftMargin: textMargins
                anchors.rightMargin: textMargins
                anchors.bottomMargin: textMargins
                anchors.topMargin: textMargins / 2
                spacing: textMargins / 2
                enabled: !settingsData.allDisabled

                GroupBox {
                    title: "BusyIndicator"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    BusyIndicator {
                        id: busyindicator
                        anchors.centerIn: parent
                        running: scrollView.visible
                    }
                }

                GroupBox {
                    title: "ProgressBar"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    ColumnLayout {
                        anchors.fill: parent
                        ProgressBar {
                            value: slider.value
                            maximumValue: slider.maximumValue
                            Layout.fillWidth: true
                        }
                        ProgressBar {
                            indeterminate: true
                            value: slider.value
                            maximumValue: slider.maximumValue
                            Layout.fillWidth: true
                        }
                    }
                }

                GroupBox {
                    title: "Slider"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    ColumnLayout {
                        anchors.fill: parent
                        Slider {
                            id: slider
                            // TODO: can't use maximumValue / 2 here, otherwise the gauges
                            // initially show up as empty; find out why.
                            value: 50
                            // If we use the default value of 1 here, we run into QTBUG-42358,
                            // even though that report specifically uses 100 as an example...
                            maximumValue: 100
                            Layout.fillWidth: true
                        }
                    }
                }

                GroupBox {
                    title: "Gauge"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    Gauge {
                        id: gauge
                        value: slider.value * 1.4
                        orientation: window.width < window.height ? Qt.Vertical : Qt.Horizontal
                        minimumValue: slider.minimumValue * 1.4
                        maximumValue: slider.maximumValue * 1.4
                        tickmarkStepSize: 20

                        anchors.centerIn: parent
                    }
                }

                GroupBox {
                    title: "CircularGauge"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    Layout.minimumWidth: 0
                    CircularGauge {
                        id: circularGauge
                        value: slider.value * 3.2
                        minimumValue: slider.minimumValue * 3.2
                        maximumValue: slider.maximumValue * 3.2

                        anchors.centerIn: parent
                        width: Math.min(implicitWidth, parent.width)
                        height: Math.min(implicitHeight, parent.height)

                        style: Flat.CircularGaugeStyle {
                            tickmarkStepSize: 20
                            labelStepSize: 40
                            minorTickmarkCount: 2
                        }

                        Column {
                            anchors.centerIn: parent

                            Label {
                                text: Math.floor(circularGauge.value)
                                anchors.horizontalCenter: parent.horizontalCenter
                                renderType: Text.QtRendering
                                font.pixelSize: unitLabel.font.pixelSize * 2
                                font.family: Flat.FlatStyle.fontFamily
                                font.weight: Font.Light
                            }
                            Label {
                                id: unitLabel
                                text: "km/h"
                                renderType: Text.QtRendering
                                font.family: Flat.FlatStyle.fontFamily
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
        }
    }

	// add the list here ============================================================================
	/* Column{
        anchors.fill: parent
        //标题栏
        Titlebar{
            id: titlebar
            onStateChanged: {
                if(state == "default")
                    addview.hide();
                else if(state == "adding")
                    addview.show();
            }
		}
        //增加事项
       AddView {
            id: addview
            width: parent.width
            onAdded: {
                titlebar.state = "default"; //恢复标题栏的状态
                if(intent.text !== ""){
                    intent.done = false;
                    list.insertItem(intent);
                    list.saveItems();
                }
            }
        }
        //已添加的事项列表
        TodoListView {
            id: list
            width: parent.width
            height: window.height - titlebar.height - addview.height
        }
    }
    //UI构建完成后，读取待办事项列表，并显示出来
    Component.onCompleted: {
        var l  = todocpp.getItems();
        console.debug(JSON.stringify(l));
        for(var i=0; i<l.length; ++i){
            list.insertItem(l[i]);
        }
    }
	property Component myListView:  TodoListView {
            id: list
            width: parent.width
            height: window.height //- titlebar.height - addview.height
    }*/
	//==============================================================================================
  /*  property Component inputComponent: ScrollView {
        id: scrollView
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        Flickable {
            anchors.fill: parent
            contentWidth: viewport.width
            contentHeight: inputcolumn.implicitHeight + textMargins * 1.5
            ColumnLayout {
                id: inputcolumn
                anchors.fill: parent
                anchors.margins: textMargins
                spacing: textMargins / 2
                enabled: !settingsData.allDisabled

                GroupBox {
                    title: "TextField"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    ColumnLayout {
                        anchors.fill: parent
                        TextField {
                            z: 1
                            placeholderText: "TextField"
                            Layout.fillWidth: true
                        }
                        TextField {
                            placeholderText: "Password"
                            echoMode: TextInput.Password // TODO: PasswordEchoOnEdit
                            Layout.fillWidth: true
                        }
                    }
                }

                GroupBox {
                    title: "ComboBox"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    visible: Qt.application.supportsMultipleWindows
                    ColumnLayout {
                        anchors.fill: parent
                        ComboBox {
                            model: ["Option 1", "Option 2", "Option 3"]
                            Layout.fillWidth: true
                        }
                        ComboBox {
                            editable: true
                            model: ListModel {
                                id: combomodel
                                ListElement { text: "Option 1" }
                                ListElement { text: "Option 2" }
                                ListElement { text: "Option 3" }
                            }
                            onAccepted: {
                                if (find(currentText) === -1) {
                                    combomodel.append({text: editText})
                                    currentIndex = find(editText)
                                }
                            }
                            Layout.fillWidth: true
                        }
                    }
                }

                GroupBox {
                    title: "SpinBox"
                    checkable: settingsData.checks
                    flat: !settingsData.frames
                    Layout.fillWidth: true
                    GridLayout {
                        anchors.fill: parent
                        columns: Math.max(1, Math.floor(scrollView.width / spinbox.implicitWidth - 0.5))
                        SpinBox {
                            id: spinbox
                            Layout.fillWidth: true
                        }
                        SpinBox {
                            decimals: 1
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }*/

    Component {
        id: tableViewComponent
        TableView {
            id: view
            enabled: !settingsData.allDisabled
            TableViewColumn {
                role: "title"
                title: "Title"
                width: view.width / 2
                resizable: false
                movable: false
            }
            TableViewColumn {
                role: "author"
                title: "Author"
                width: view.width / 2
                resizable: false
                movable: false
            }

            frameVisible: false
            backgroundVisible: true
            alternatingRowColors: false
            model: ListModel {
                ListElement {
                    title: "Moby-Dick"
                    author: "Herman Melville"
                }
                ListElement {
                    title: "The Adventures of Tom Sawyer"
                    author: "Mark Twain"
                }
                ListElement {
                    title: "Cat’s Cradle"
                    author: "Kurt Vonnegut"
                }
                ListElement {
                    title: "Farenheit 451"
                    author: "Ray Bradbury"
                }
                ListElement {
                    title: "It"
                    author: "Stephen King"
                }
                ListElement {
                    title: "On the Road"
                    author: "Jack Kerouac"
                }
                ListElement {
                    title: "Of Mice and Men"
                    author: "John Steinbeck"
                }
                ListElement {
                    title: "Do Androids Dream of Electric Sheep?"
                    author: "Philip K. Dick"
                }
                ListElement {
                    title: "Uncle Tom’s Cabin"
                    author: "Harriet Beecher Stowe"
                }
                ListElement {
                    title: "The Call of the Wild"
                    author: "Jack London"
                }
                ListElement {
                    title: "The Old Man and the Sea"
                    author: "Ernest Hemingway"
                }
                ListElement {
                    title: "A Streetcar Named Desire"
                    author: "Tennessee Williams"
                }
                ListElement {
                    title: "Catch-22"
                    author: "Joseph Heller"
                }
                ListElement {
                    title: "One Flew Over the Cuckoo’s Nest"
                    author: "Ken Kesey"
                }
                ListElement {
                    title: "The Murders in the Rue Morgue"
                    author: "Edgar Allan Poe"
                }
                ListElement {
                    title: "Breakfast at Tiffany’s"
                    author: "Truman Capote"
                }
                ListElement {
                    title: "Death of a Salesman"
                    author: "Arthur Miller"
                }
                ListElement {
                    title: "Post Office"
                    author: "Charles Bukowski"
                }
                ListElement {
                    title: "Herbert West—Reanimator"
                    author: "H. P. Lovecraft"
                }
            }
        }
    }
    Component {
        id: calendarComponent
        Item {
            enabled: !settingsData.allDisabled
            Calendar {
                anchors.centerIn: parent
                weekNumbersVisible: true
                frameVisible: settingsData.frames
            }
        }
    }
    Component {
        id: textAreaComponent
        TextArea {
            enabled: !settingsData.allDisabled
            frameVisible: false
            flickableItem.flickableDirection: Flickable.VerticalFlick
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum quis justo a sem faucibus mattis nec vitae nisi. Fusce fringilla nulla a tellus vehicula sodales. Etiam volutpat suscipit erat vitae adipiscing. Sed vestibulum massa nisl, eget posuere urna porta ac. Morbi at nunc ligula. Cras et mauris aliquet ligula sodales suscipit eget imperdiet augue. Ut eget dui eu magna malesuada imperdiet. Donec imperdiet urna eu consequat ornare. Cras at metus tristique, ullamcorper nisl ut, faucibus mauris. Fusce in euismod arcu. Donec tristique rutrum porta. Praesent mattis ac tortor quis scelerisque. Integer luctus nulla ut lacinia tempus."
        }
    }
    Component {
        id: pieMenuComponent
        Item {
            enabled: !settingsData.allDisabled

            Column {
                anchors.fill: parent
                anchors.bottom: parent.bottom
                anchors.bottomMargin: controlData.textMargins
                spacing: Math.round(controlData.textMargins * 0.5)

                Image {
                    id: pieMenuImage
                    source: "qrc:/images/piemenu-image-rgb.jpg"
                    fillMode: Image.PreserveAspectFit
                    width: parent.width
                    height: Math.min((width / sourceSize.width) * sourceSize.height, (parent.height - parent.spacing) * 0.88)
                }
                Item {
                    width: parent.width
                    height: parent.height - pieMenuImage.height - parent.spacing

                    Text {
                        id: instructionText
                        anchors.fill: parent
                        anchors.leftMargin: controlData.textMargins
                        anchors.rightMargin: controlData.textMargins
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: "Tap and hold to open menu"
                        font.family: Flat.FlatStyle.fontFamily
                        font.pixelSize: Math.round(20 * Flat.FlatStyle.scaleFactor)
                        fontSizeMode: Text.Fit
                        color: Flat.FlatStyle.lightFrameColor
                    }
                }
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onPressAndHold: pieMenu.popup(mouse.x, mouse.y)
            }
            PieMenu {
                id: pieMenu
                triggerMode: TriggerMode.TriggerOnClick

                MenuItem {
                    iconSource: "qrc:/images/piemenu-rgb-" + (pieMenu.currentIndex === 0 ? "pressed" : "normal") + ".png"
                    onTriggered: pieMenuImage.source = "qrc:/images/piemenu-image-rgb.jpg"
                }
                MenuItem {
                    iconSource: "qrc:/images/piemenu-bw-" + (pieMenu.currentIndex === 1 ? "pressed" : "normal") + ".png"
                    onTriggered: pieMenuImage.source = "qrc:/images/piemenu-image-bw.jpg"
                }
                MenuItem {
                    iconSource: "qrc:/images/piemenu-sepia-" + (pieMenu.currentIndex === 2 ? "pressed" : "normal") + ".png"
                    onTriggered: pieMenuImage.source = "qrc:/images/piemenu-image-sepia.jpg"
                }
            }
        }
    }
    Component {
        id: delayButtonComponent
        Item {
            enabled: !settingsData.allDisabled
            DelayButton {
                text: progress < 1 ? "START" : "STOP"
                anchors.centerIn: parent
            }
        }
    }
    Component {
        id: dialComponent
        Item {
            enabled: !settingsData.allDisabled
            Dial {
                anchors.centerIn: parent
            }
        }
    }
   /*
    Component {
        id: tumblerComponent
        Item {
            enabled: !settingsData.allDisabled
            Tumbler {
                anchors.centerIn: parent
                TumblerColumn {
                    model: {
                        var hours = [];
                        for (var i = 1; i <= 24; ++i)
                            hours.push(i < 10 ? "0" + i : i);
                        hours;
                    }
                }
                TumblerColumn {
                    model: {
                        var minutes = [];
                        for (var i = 0; i < 60; ++i)
                            minutes.push(i < 10 ? "0" + i : i);
                        minutes;
                    }
                }
            }
        }
    }*/


    Button{
        id : addButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text : "+"
        onClicked: {
           parent.addBClicked=true
           midContent.castMessage("clicked here!!")
        }
    }


}
