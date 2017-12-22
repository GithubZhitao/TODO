import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Extras 1.4
import QtQuick.XmlListModel 2.0


Item{

    anchors.fill: parent
    FontMetrics {
        id: fontMetrics
        font.family: Flat.FlatStyle.fontFamily
    }
    Loader {
        id: componentLoader
        anchors.fill: parent
        //sourceComponent: addBClicked?inputComponent:componentModel[controlData.componentIndex].component
        sourceComponent: inputComponent
    }



property Component inputComponent: ScrollView {
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
}
}
