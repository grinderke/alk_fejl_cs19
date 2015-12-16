import QtQuick 2.4
import QtQuick.Controls 1.4

ApplicationWindow {
    id: root
    height: 220
    minimumHeight: 220
    title: "Csapattagok"


    Column{
        id: columnID
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
        anchors.top: image.bottom
        anchors.topMargin: 10
        x: 50
    }
    Text {
        //anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Hably Alexandra")
        anchors.top: image.bottom
        anchors.topMargin: 25
        x: 100

    }
    Text {
        //anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Kardos Tamás")
        anchors.top: image.bottom
        anchors.topMargin: 40
        x: 100

    }
    Text {
        //anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Krcs Dávid")
        anchors.top: image.bottom
        anchors.topMargin: 55
        x: 100
    }
    }
}
