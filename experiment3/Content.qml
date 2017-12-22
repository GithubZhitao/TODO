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
        { name: "今日事件", component: mywindow },
        { name: "按周显示", component: calendarComponent },
        { name: "月历", component: calendarComponent },
        { name: "表格显示内容", component: calendarComponent },
        { name: "帮助", component: textAreaComponent }
    ]

    Loader
    {
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


                GroupBox {
                    title: "事件"

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

                    }
                }



                GroupBox{
                  //  title: ""

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

// the new component model




    property Component mywindow: Collec {
        id:window
        visible: true
    }

    Component {
        id: calendarComponent
        Item {
            Calendar {
                anchors.centerIn: parent
                weekNumbersVisible: true
            }
        }
    }
    Component {
        id: textAreaComponent
        TextArea {
            frameVisible: false
            flickableItem.flickableDirection: Flickable.VerticalFlick
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum quis justo a sem faucibus mattis nec vitae nisi. Fusce fringilla nulla a tellus vehicula sodales. Etiam volutpat suscipit erat vitae adipiscing. Sed vestibulum massa nisl, eget posuere urna porta ac. Morbi at nunc ligula. Cras et mauris aliquet ligula sodales suscipit eget imperdiet augue. Ut eget dui eu magna malesuada imperdiet. Donec imperdiet urna eu consequat ornare. Cras at metus tristique, ullamcorper nisl ut, faucibus mauris. Fusce in euismod arcu. Donec tristique rutrum porta. Praesent mattis ac tortor quis scelerisque. Integer luctus nulla ut lacinia tempus."
        }
    }

    ActionButton{
        id : addButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text : "添加详细提醒"
        icon: "assets/timerEvents.png"
      //  iconSource:{ source:"assets/timerEvents.png"}
        onClicked: {
           parent.addBClicked=true
           midContent.castMessage("clicked here!!")
        }
    }


}
