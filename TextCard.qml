import QtQuick
import QtQuick.Layouts

Card {
    id: root

    property string title: ""
    property string text: ""
    property var textLines: []

    ColumnLayout {
        id: contentColumn
        spacing: 8
        anchors.fill: parent

        Text {
            id: titleText
            Layout.fillWidth: true
            text: root.title
            color: root.titleColor
            font.pixelSize: 20
            font.weight: Font.DemiBold
            wrapMode: Text.WordWrap
            visible: root.title !== ""
        }

        Text {
            id: bodyText
            Layout.fillWidth: true
            Layout.fillHeight: root.textLines.length === 0
            text: root.text
            color: root.textColor
            font.pixelSize: 18
            wrapMode: Text.WordWrap
            visible: root.text !== "" && root.textLines.length === 0
        }

        Repeater {
            model: root.textLines

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: index === root.textLines.length - 1
                Layout.topMargin: index > 0 ? 4 : 0
                text: modelData
                color: root.textColor
                font.pixelSize: 18
                wrapMode: Text.WordWrap
            }
        }
    }
}
