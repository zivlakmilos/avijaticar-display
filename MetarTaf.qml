import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Dialogs

Base {
    id: root

    property color buttonColor: root.lightMode ? "#e0e0e0" : "#2d2d2d"
    property color buttonHoverColor: root.lightMode ? "#d0d0d0" : "#404040"
    property color buttonPressedColor: root.lightMode ? "#c0c0c0" : "#454545"
    property color buttonTextColor: root.lightMode ? "#1a1a1a" : "#f0f0f0"

    GridLayout {
        anchors.centerIn: parent
        columns: 2

        Repeater {
            model: weather.airports

            TextCard {
                title: modelData.icaoId
                textLines: [
                    modelData.metar || "No METAR available",
                    modelData.taf || "No TAF available"
                ]
                clickable: true
                implicitWidth: 500
            }
        }
    }

    Button {
        id: printButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16
        text: "🖨 Print All"

        onClicked: {
        }

        background: Rectangle {
            implicitWidth: 120
            implicitHeight: 48
            radius: 8
            color: printButton.pressed ? root.buttonPressedColor
                 : printButton.hovered ? root.buttonHoverColor
                 : root.buttonColor
        }

        contentItem: Text {
            text: printButton.text
            font.pixelSize: 16
            color: root.buttonTextColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
