import QtQuick 2.4
import QtQuick.Controls 1.3

ApplicationWindow {
    id: root
    title: "Csapattagok"


    Column{
        anchors.fill: parent
    Image {
        source: "pics/autlogo.png"
        id: image
        anchors.top: parent.top
        anchors.topMargin: 10
        x: 50
        //y: 20
         }
    Text {
        text: qsTr("A csapattagok:")
        anchors.top: parent.top
        anchors.topMargin: 220
        x: 50
    }
    Text {
        //anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Hably Alexandra")
        anchors.top: parent.top
        anchors.topMargin: 240
        x: 100

    }
    Text {
        //anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Kardos Tamás")
        anchors.top: parent.top
        anchors.topMargin: 255
        x: 100

    }
    Text {
        //anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Krcs Dávid")
        anchors.top: parent.top
        anchors.topMargin: 270
        x: 100
    }
    }
}
