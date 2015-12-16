import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2

Item {

    anchors.fill: parent
    objectName: "MainWindow"

    property alias button3: button3
    property alias button2: button2
    property alias button1: button1
    property color selectedColor : "grey"

    signal socketConnect();

    function socketConnection(messageText, color)
       {
           selectedColor = color;
           eventLogModel.insert(0, { message: messageText, colorCode: color } );
           console.log("selectColor(" + messageText + ", " + color + ")");
       }

    ColumnLayout {
        id: baseGrid
        anchors.fill: parent
        anchors.margins: 10

        GroupBox{

         Column{
         spacing: 70
         anchors.bottom: eventLog

         Button {
             id: button1
             text: qsTr("Connect")
             style: ButtonStyle {
                     id: buttonstyle1
                     background: Rectangle {
                         implicitWidth: 120
                         implicitHeight: 40
                         border.width: 2
                         border.color: "#888"
                     }}
             onClicked: socketConnect();
         }

         Button {
             id: button2
             text: qsTr("Start")
             style: ButtonStyle {
                     background: Rectangle {
                         implicitWidth: 120
                         implicitHeight: 40
                         border.width: 2
                         border.color: "#888"
                     }}
         }

         Button {
             id: button3
             text: qsTr("Unknown")
             style: ButtonStyle {
                     background: Rectangle {
                         implicitWidth: 120
                         implicitHeight: 40
                         border.width: 2
                         border.color: "#888"
                     }}
         }
       }
     }

        GroupBox
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

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

}
