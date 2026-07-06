import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtWebView

ApplicationWindow {
    id: window
    width: 640
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    title: qsTr("Avijatičar")
    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property color reallyDark: "#1f1f1f"
    property color dark: "#262626"
    property color reallyLight: "#e7e7e7"
    property color light: "#e0e0e0"

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton { text: qsTr("METAR TAF") }
        TabButton { text: qsTr("Mass and Balance") }
        TabButton { text: qsTr("Flight Plan") }
        TabButton { text: qsTr("Weather") }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        Page {
            Label {
                text: "METAR & TAF"
                anchors.centerIn: parent
                font.pixelSize: 16
                font.bold: true
            }
        }
        Page {
            Label {
                text: "Mass and Balance"
                anchors.centerIn: parent
                font.pixelSize: 16
                font.bold: true
            }
        }
        Page {
            Label {
                text: "Flight Plan"
                anchors.centerIn: parent
                font.pixelSize: 16
                font.bold: true
            }
        }
        Page {
            WebView {
                anchors.fill: parent
                url: "https://www.ventusky.com/total-cloud-cover-map#p=45.27;20.25;7"
            }
        }
    }
}
