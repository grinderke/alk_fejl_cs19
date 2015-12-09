import QtQuick 2.4
import QtQuick.Controls 1.3

ApplicationWindow {
    id: root
    width: 300; height: 300
    title: "Fejlesztők"

    Column{
    Image {
        source: "pics/developers.jpg"
        x: 50
        y: 20
         }
    Text {
       // anchors.centerIn: parent
        text: qsTr("A csapattagok:")
        x: 50
        y: 20
    }
    Text {
       // anchors.centerIn: parent
        text: qsTr("Hably Alexandra")
        x: 50
        y: 20
    }
    Text {
       // anchors.centerIn: parent
        text: qsTr("Kardos Tamás")
        x: 50
        y: 40
    }
    Text {
       // anchors.centerIn: parent
        text: qsTr("Krcs Dávid")
        x: 50
        y: 60
    }
    }
}
