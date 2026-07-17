import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root

    property bool clickable: false
    signal clicked()

    property bool lightMode: typeof window !== "undefined" ? window.lightMode : Application.styleHints.colorScheme === Qt.Light

    property color backgroundColor: lightMode ? "#ffffff" : "#2d2d2d"
    property color hoverColor: lightMode ? "#f5f5f5" : "#383838"
    property color pressedColor: lightMode ? "#ebebeb" : "#404040"
    property color titleColor: lightMode ? "#1a1a1a" : "#f0f0f0"
    property color textColor: lightMode ? "#4a4a4a" : "#b0b0b0"
    property color borderColor: lightMode ? "#e0e0e0" : "#404040"
    property color shadowColor: lightMode ? "#20000000" : "#40000000"

    default property alias contentData: content.data

    implicitWidth: 280
    implicitHeight: 200

    Rectangle {
        id: shadow
        anchors.fill: background
        anchors.topMargin: 2
        anchors.leftMargin: 1
        anchors.rightMargin: -1
        anchors.bottomMargin: -2
        radius: background.radius
        color: root.shadowColor
        visible: root.clickable
    }

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 12
        color: {
            if (!root.clickable) return root.backgroundColor
            if (mouseArea.pressed) return root.pressedColor
            if (mouseArea.containsMouse) return root.hoverColor
            return root.backgroundColor
        }
        border.width: 1
        border.color: root.borderColor

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        scale: root.clickable && mouseArea.pressed ? 0.98 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
        }

        Item {
            id: content
            anchors.fill: parent
            anchors.margins: 16
            clip: true
        }
      }

      MouseArea {
          id: mouseArea
          anchors.fill: parent
          enabled: root.clickable
          hoverEnabled: root.clickable
          cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor

          onClicked: {
              if (root.clickable) {
                  root.clicked()
              }
          }
      }
}
