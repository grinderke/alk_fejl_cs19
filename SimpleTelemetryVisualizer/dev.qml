import QtQuick 2.4
import QtQuick.Controls 1.3

ApplicationWindow {
    id: root
    title: "Csapattagok"

    Column{
    Image {
        source: "pics/autlogo.png"
        x: 50
         }
    Text {
        text: qsTr("A csapattagok:")
        x: 50
    }
    Text {
        text: qsTr("Hably Alexandra")
        x: 50
    }
    Text {
        text: qsTr("Kardos Tamás")
        x: 50
    }
    Text {
        text: qsTr("Krcs Dávid")
        x: 50
    }
    }
}
