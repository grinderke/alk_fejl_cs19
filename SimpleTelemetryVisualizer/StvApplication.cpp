#include "StvApplication.h"

StvApplication::StvApplication(int argc, char *argv[])
    : QApplication(argc, argv), simulator(3333), engine(), history(), communication(),
      robot(history, communication), handler(robot, *engine.rootContext(), history)
{
    // Szimulálunk egy history változást, mert attól kezdve léteznek a QML oldalon
    //  a C++ oldalról származó változók. (Különben referencia hibákat kapnánk a QML oldalon
    //  egészen addig, amíg az első üzenet meg nem jönne a szimulátortól.
    handler.historyChanged();

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    // A QML gyökérelemre szükségünk van ahhoz, hogy tudjunk hivatkozni a QML-es elemekre.
    auto rootObjects = engine.rootObjects();

    if (rootObjects.size() == 0)
    {
        qDebug() << "HIBA: Nem sikerült létrehozni a QML környezetet.";
        return;
    }

    // A QML környezet is felállt, bekötjük a signalokat a QML és C++ oldal között.
    QObject *rootObject = rootObjects[0];
    // Átadjuk a rootObject-et a handler-nek
    handler.rootObject = rootObjects[0];
    // A handler beköti a saját signaljait.
    handler.ConnectQmlSignals(rootObject);

    // Bekötjük a nyomógombok signaljait.
    QObject::connect(rootObject, SIGNAL(startCommandCpp()),
                     &handler, SLOT(startCommand()));
    QObject::connect(rootObject, SIGNAL(resetCommandCpp()),
                     &handler, SLOT(resetCommand()));
    QObject::connect(rootObject, SIGNAL(accelerateCommandCpp()),
                     &handler, SLOT(accelerateCommand()));
    QObject::connect(rootObject, SIGNAL(stopCommandCpp()),
                     &handler, SLOT(stopCommand()));
    QObject::connect(&handler, SIGNAL(startSimulatorCpp()),
                     this, SLOT(startSimulator()));
}
//Szimulátor indítása és kommunikáció felállítása.
void StvApplication::startSimulator(){
    simulator.start(1.0F);
    communication.connect(QStringLiteral("localhost"),3333);
}
