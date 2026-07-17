import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root

    property bool lightMode: typeof window !== "undefined" ? window.lightMode : Application.styleHints.colorScheme === Qt.Light

    property color backgroundColor: lightMode ? "#f5f5f5" : "#1a1a1a"

    default property alias contentData: content.data

    Rectangle {
        id: background
        anchors.fill: parent
        color: root.backgroundColor

        Item {
            id: content
            anchors.fill: parent
        }
    }
}
