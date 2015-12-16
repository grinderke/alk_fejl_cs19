import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

// Ez lesz az alkalmazás főablaka
ApplicationWindow {
    title: qsTr("Szimulátor")
    id: root
    width: 820
    height: 620
    visible: true

    // Signalok, melyeket a C++ oldalon fogunk C++ slotokhoz kötni
    //  az StvApplication osztály konstruktorában.
    signal startCommandCpp()
    signal resetCommandCpp()
    signal accelerateCommandCpp()
    signal stopCommandCpp()

    // Az ablak menuBar tulajdonságának értékül adunk egy MenuBar példányt, amit itt rakunk össze.
    menuBar: MenuBar {
        // A MenuBar-on belül vannak a menük, Menu példányok formájában. Most csak egy "Exit" menünk van,
        //  benne egyetlen menüponttal.
        Menu {
            // A menünek a title tulajdonsága egyúttal az & jellel megadja a billentyű parancsot is: Alt-x
            title: qsTr("&Fájl")
            // Az egyetlen menüpont
            MenuItem {
                text: qsTr("&Csapattagok")
                onTriggered: {
                var component = Qt.createComponent("dev.qml")
                var window    = component.createObject(root)
                window.height = 200
                window.width = 400
                window.show()
                }
            }
            MenuItem {
                text: qsTr("&Kilépés")
                // A menüpont Triggered signaljához kapcsolunk eseménykezelőt
                //  úgy, hogy értéket adunk az onTriggered tulajdonságnak. Az eseménykezelőt
                //  JavaScript nyelven írjuk meg.
                onTriggered: Qt.quit();
            }
        }
    }

    /* Instantiating the MainForm control which contains everything in the main form,
        except the menu. */
    // A MainForm elem példányosítása. Itt adjuk meg az ID-ját, a helyét (anchors),
    //  valamint a signaljainak az eseménykezelőit.
    MainForm {
        id: mainFormControl
        anchors.fill: parent

        // Az eseménykezelőkben tovább hívjuk az itteni signalokat a C++ oldal felé.
        onStartCommand: {
            startCommandCpp();
        }
        onResetCommand: {
            resetCommandCpp();
        }
        onAccelerateCommand: {
            accelerateCommandCpp();
        }
        onStopCommand: {
            stopCommandCpp();
        }
    }
}
