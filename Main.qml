import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

ApplicationWindow {
    id: window
    width: 640
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    title: qsTr("Avijatičar")
    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property bool userOverrideTheme: false
    property bool userLightMode: true

    function toggleTheme() {
        if (!userOverrideTheme) {
            userOverrideTheme = true
            userLightMode = !lightMode
        } else {
            userLightMode = !userLightMode
        }
        lightMode = userLightMode
    }

    header: RowLayout {
        spacing: 0

        Rectangle {
            id: background
            anchors.fill: parent
            color: lightMode ? "#f5f5f5" : "#1a1a1a"
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            currentIndex: swipeView.currentIndex
            TabButton { text: qsTr("METAR && TAF") }
            TabButton { text: qsTr("Mass && Balance") }
            TabButton { text: qsTr("Flight Plan") }
            TabButton { text: qsTr("Weather") }
        }

        Button {
            id: themeToggle
            text: window.lightMode ? "\u2600" : "\u{1F319}"
            font.pixelSize: 24
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            Layout.alignment: Qt.AlignVCenter
            onClicked: window.toggleTheme()

            background: Rectangle {
                color: themeToggle.pressed ? (window.lightMode ? "#d0d0d0" : "#404040") 
                     : themeToggle.hovered ? (window.lightMode ? "#e0e0e0" : "#353535")
                     : "transparent"
            }

            contentItem: Text {
                text: themeToggle.text
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        Page {
            MetarTaf {
                anchors.fill: parent
            }
        }
        Page {
            MassBalance {
                anchors.fill: parent
            }
        }
        Page {
            FlightPlan {
                anchors.fill: parent
            }
        }
        Page {
            Loader {
                anchors.fill: parent
                source: "Radar.qml"
            }
        }
    }
}
