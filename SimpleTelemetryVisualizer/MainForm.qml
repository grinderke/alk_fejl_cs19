import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.3

Item {
    width: 500
    height: 500
    anchors.fill: parent
    objectName: "MainForm"
    id: valami;
    // Signalok, melyek a kiadott parancsokat jelzik és a nyomógombok
    //  eseménykezelői aktiválják őket.

    signal startCommand;
    signal resetCommand;
    signal accelerateCommand;
    signal stopCommand;

    function selectColor(messageText, color)
           {
               var selectedColor = color;
               eventLogModel.insert(0, { message: messageText, colorCode: color } );
               console.log("selectColor(" + messageText + ", " + color + ")");
           }

    function getTextValue()
    {
        return accelerateTextField.text;
    }

    // A parancs nyomógombok elemcsoportja
    GroupBox {
        id: commandsGB
        title: "Parancsok"
        // Bal oldalon és fent követi a szülőt. A szélessége fix.
        anchors.left : parent.left
        anchors.top : parent.top
        width: 200
        // A nyomógombokat oszlopba rendezzük
        ColumnLayout {
            id: columnLayout1
            spacing: 10
            // Az oszlop kitölti a szülőt, vagyis a commandsGB-t.
            anchors.fill: parent

            // Reset nyomógomb. Oldal irányba kitöltik a szülőt, 0 pixel margó kihagyásával.
            //  Megnyomása esetén (Button.Clicked signal) meghívja a resetCommand signalt. (Ez
            //  a signal látható innen, mivel a Button egyik ősében definiáltuk.)
            Button {
                id: startBtn
                property string gradcolor1: "#ccc"
                property string gradcolor2: "#eee"
                property string gradcolor3: "#aaa"
                property string gradcolor4: "#ccc"
                objectName: "cntBtn"
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Indítás")
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                onClicked: startCommand()
                style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            //color: "#0c0"
                            gradient:
                                Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? startBtn.gradcolor1 : startBtn.gradcolor2 }
                                GradientStop { position: 1 ; color: control.pressed ? startBtn.gradcolor3 : startBtn.gradcolor4 }
                            }
                        }
                    }
            }
            Button {
                id: resetBtn
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Reset")
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                onClicked: resetCommand()
                style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                    }
            }
            TextField {
                id: accelerateTextField
                Layout.fillWidth: true
                placeholderText: "Ide írd be a gyorsulás értékét..."
                //property string someNumber: accelerateTextField.text
                      }
            Button {
                id: accelerateBtn
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Gyorsítás")
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                onClicked: accelerateCommand()
                style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                    }
            }
            Button {
                id: stopBtn
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Stop")
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                onClicked: stopCommand()
                style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                    }
            }
        }
    }

    // Aktuális értékek elemcsoportja
    GroupBox {
        id: currentValuesGB
        title: "Pillanatnyi értékek"
        // Fent és jobbra kitölti a szülőt. Balról illeszkedik a
        //  parancsok GroupBox-ának jobb széléhez.
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left : commandsGB.right
        anchors.top : parent.top
        anchors.bottom: sensorValuesGB.top

        // Oszlopba rendezett további elemek
        ColumnLayout {
            // Felfelé, lefelé és balra a szülő széléhez illeszkedik. Jobbra nem, mert
            //  széthúzni felesleges őket.
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            // Sima szövegek (Text elemek), amiknek az értéke egy a C++ oldalon definiált currentState
            //  értékétől függ. (Ha az értéke null, akkor "?" jelenik meg.)
            // A currentState-et a MainWindowsEventHandling::historyChanged metódus regisztrálja be, hogy
            //  látható legyen a QML oldalról is. (Hivatkozás a RobotStateHistory::currentState-re.)
            Text { text: " Állapot: " + (currentState!=null ? currentState.statusName : "?") }
            Text { text: " Idő: " + (currentState!=null ? currentState.timestamp : "?") }
            Text { text: " X: " + (currentState!=null ? currentState.x.toFixed(3) : "?") }
            Text { text: " V: " + (currentState!=null ? currentState.v.toFixed(3) : "?") }
            Text { text: " A: " + (currentState!=null ? currentState.a.toFixed(3) : "?") }
            Text { text: " Lámpa: " + (currentState!=null ? currentState.light.toString() : "?") }
        }
    }
    GroupBox {
        id: sensorValuesGB
        title: "Vonalszenzor értékek"
        anchors.top: currentValuesGB.bottom
        anchors.left: commandsGB.right
        anchors.right: parent.right
        anchors.bottom: graphGB.top

        RowLayout{
            spacing: 7
        Column{
            Rectangle {
            id: line1
            objectName: "rect0"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }
            Text{
            objectName: "text0"
            font.pixelSize: 10
            text: " ?"
            }
        }
        Column{
        Rectangle {
            id: line2
            objectName: "rect1"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }
        Text{
            objectName: "text1"
            font.pixelSize: 10
            text: " ?"
          }
        }
        Column{
        Rectangle {
            id: line3
            objectName: "rect2"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text2"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line4
            objectName: "rect3"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text3"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line5
            objectName: "rect4"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text4"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line6
            objectName: "rect5"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text5"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line7
            objectName: "rect6"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text6"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line8
            objectName: "rect7"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text7"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line9
            objectName: "rect8"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text8"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line10
            objectName: "rect9"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text9"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line11
            objectName: "rect10"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text10"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line12
            objectName: "rect11"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text11"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line13
            objectName: "rect12"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text12"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line14
            objectName: "rect13"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text13"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line15
            objectName: "rect14"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text14"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Column{
        Rectangle {
            id: line16
            objectName: "rect15"
            border.color: "black"
            border.width: 1
            width: 30
            height: 40
        }Text{
            objectName: "text15"
            font.pixelSize: 10
            text: " ?"
              }
            }
        Item {
            Layout.fillHeight: true
           }
    }
    }

    // Delegate: this is the appearance of a list item
    // A későbbi history listának szüksége van egy delegate-re. Minden lista elem ennek a komponensnek egy
    //  példánya lesz.
    Component {
        // ID, hogy tudjuk a listánál hivatkozni erre, mint a lista delegatejére.
        id: stateDelegate
        Row {
            // Itt a model az, ami a list egyik eleme. (Bármi is legyen majd az.)
            Text { text: model.statusName }
            Text { text: " X: " + model.x.toFixed(3) }
            Text { text: " V: " + model.v.toFixed(3) }
            Text { text: " A: " + model.a.toFixed(3) }
        }
    }

    // Az állapot lista és a grafikon GroupBoxa.
    GroupBox {
        id: graphGB
        title: qsTr("Grafikon")
        // Oldalra és lefelé kitölti a szülőt.
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        //anchors.bottom: eventLog.top
        anchors.bottomMargin: 0
        // Felfelé a commandsGB és currentValuesGB GroupBoxok közül ahhoz igazodik, aminek lejjebb van az alja.
        //anchors.top: (commandsGB.bottom > currentValuesGB.bottom ? commandsGB.bottom : currentValuesGB.bottom )
        anchors.top: commandsGB.bottom
        anchors.topMargin: 0

        // Sorban egymás mellett van a lista és a grafikon
        RowLayout {
            // Kitölti a szülőt és nem hagy helyet az elemek között.
            anchors.fill: parent
            spacing: 0
            // A history lista egy scrollozható elemen belül van.
            ScrollView {
                // A scrollohzató elem igazítása a szölő RowLayouthoz.
                // Itt a ScrollViewon belül adjuk meg, hogy a RowLayoutban
                //  mik legyenek a rá (ScrollViewra) vonatkozó méret beállítások,
                //  mert ezeket a RowLayout kezeli ebben az esetben.
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumWidth: 250
                Layout.preferredWidth: 250
                Layout.maximumWidth: 300
                Layout.minimumHeight: 150

                // Itt jön a tényleges lista.
                ListView {
                    id: stateHistoryList
                    // A model az, ahonnan az adatokat vesszük.
                    // A historyModel változót a MainWindowsEventHandling::historyChanged metódus teszi
                    //  elérhetővé a QML oldalon is.
                    //  Típusa QList<QObject*>, a tárolt pointerek valójában RobotState-ekre mutatnak.
                    model: historyModel
                    // A delegate megadása, vagyis hogy egy listaelem hogyan jelenjen meg.
                    //  (Már fentebb definiáltuk.)
                    delegate: stateDelegate

                    // Eseménykezelő, az elemek darabszámának változása esetén a kijelölést
                    //  a legalsó elemre viszi. Ezzel oldja meg, hogy folyamatosan scrollozódjon
                    //  a lista és a legutoló elem mindig látható legyen.
                    onCountChanged: {
                        stateHistoryList.currentIndex = stateHistoryList.count - 1;
                    }
                }
            }

            // A HistoryGraph példányosítása, melyet külön fájlban definiáltunk.
            //  (A rendszer név alapján találja meg a fájlt.)
            HistoryGraph {
                id: historyGraph
                // Az objectName akkor jó, ha C++ oldalról kell megkeresnünk egy QML oldalon definiált
                //  objektumot a findChild metódus rekurzív hívásaival.
                objectName: "historyGraph"

                // A RowLayout erre az elemre vonatkozó elhelyezés beállításai.
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumWidth: 200
                Layout.preferredWidth: 400
                Layout.minimumHeight: 200

                // Ezek pedig a HistoryGraph tulajdonságai, amiket majd ott definiálunk,
                //  itt pedig értéket adunk nekik. Az alábbi változókat (pl. historyGraphTimestamps)
                //  szintén a MainWindowsEventHandling::historyChanged metódus teszi elérhetővé
                //  a QML oldal számára.
                // Ezek az értékek C++ oldalon folyamatosan változnak. Minden változás esetén
                //  lefut a MainWindowsEventHandling::historyChanged és ezeket újraregisztrálja a QML
                //  oldal számára, így frissülni fog a HistoryGraph tulajdonság is.
                graphTimestamps: historyGraphTimestamps
                graphVelocities: historyGraphVelocity
                graphAccelerations: historyGraphAcceleration
            }
        }
     }
    GroupBox
            {
                title: "Event log"
                anchors.top: graphGB.bottom
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0

                //Layout.fillHeight: true
                //Layout.fillWidth: true

                ListView {
                    id: eventLog
                    anchors.fill: parent
                    anchors.margins: 10
                    delegate: GroupBox {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        Row {
                            id: row2
                            Rectangle {
                                width: 40
                                height: 20
                                color: colorCode
                            }
                            Text {
                                text: message
                                anchors.verticalCenter: parent.verticalCenter
                                font.bold: true
                            }
                            spacing: 10
                        }
                    }
                    model: ListModel {
                        id: eventLogModel
                        ListElement {
                            message: "Az alkalmazás elindult"
                            colorCode: "grey"
                        }
                    }
                }
            }
}
