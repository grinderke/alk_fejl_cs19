import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: root
    title: "Simulator"
    width: 640
    height: 480
    visible: true

    // A C++ oldal számára
    objectName: "ApplicationWindow"

    menuBar: MenuBar {
        Menu {
            title: "&File"
            MenuItem {
                text: qsTr("&Developers")
                onTriggered: {
                    var component = Qt.createComponent("dev.qml")
                    var window    = component.createObject(root)
                    window.height = 300
                    window.width = 300
                    window.show()
                }
            }
            MenuItem {
                text: "&Exit"
                onTriggered: Qt.quit();
            }
        }
    }
    MainWindow
    {

    }
}
