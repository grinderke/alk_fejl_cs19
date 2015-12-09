import QtQuick 2.3
import QtQuick.Controls 1.2

ApplicationWindow {
    id: root
    width: 300; height: 300

    Text {
        anchors.centerIn: parent
        text: qsTr("Hello World.")
    }
}
