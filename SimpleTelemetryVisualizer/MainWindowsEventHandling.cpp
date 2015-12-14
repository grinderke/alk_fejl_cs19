#include "MainWindowsEventHandling.h"
#include "RobotProxy.h"
#include "RobotState.h"
#include <QQmlContext>
#include "RobotStateHistory.h"
#include <QVector>
#include <QQuickItem>
#include <QQmlProperty>
#include <QQmlApplicationEngine>

MainWindowsEventHandling::MainWindowsEventHandling(
        RobotProxy &robot, QQmlContext& qmlContext, RobotStateHistory& history)
    : robot(robot), qmlContext(qmlContext), history(history)
{
    QObject::connect(&history, SIGNAL(historyChanged()), this, SLOT(historyChanged()));
    QObject::connect(&history, SIGNAL(historyChanged()), this, SLOT(lineChanged()));
}

void MainWindowsEventHandling::startCommand()
{
    emit startSimulatorCpp();
    auto mainForm = FindItemByName(rootObject,"MainForm");
    // Metódus meghívása
    QVariant returnedValue;
    QVariant messageText = "Csatlakozás sikeres";
    QVariant color = "green";
    qDebug() << "selectColor QML függvény meghívása...";
    QMetaObject::invokeMethod(mainForm, "selectColor",
    Q_RETURN_ARG(QVariant, returnedValue),
        Q_ARG(QVariant, messageText),
        Q_ARG(QVariant, color));

}

void MainWindowsEventHandling::accelerateCommand()
{
    auto mainForm = FindItemByName(rootObject,"MainForm");
    // Metódus meghívása
    QVariant returnedValue;
    QVariant messageText = "Gyorsítási parancs elküldve";
    QVariant color = "yellow";
    qDebug() << "selectColor QML függvény meghívása...";
    QMetaObject::invokeMethod(mainForm, "selectColor",
    Q_RETURN_ARG(QVariant, returnedValue),
        Q_ARG(QVariant, messageText),
        Q_ARG(QVariant, color));
    QMetaObject::invokeMethod(mainForm, "getTextValue",
    Q_RETURN_ARG(QVariant, returnedValue));
    bool ok;
    float Acc = returnedValue.toFloat(&ok);
    if(ok)
     {
        robot.acceleration = Acc;
    }
    else
     {
        qDebug() << "A gyorsulás értéke nem szám!";
    }
    robot.accelerate();
}

void MainWindowsEventHandling::stopCommand()
{
    robot.stop();
    auto mainForm = FindItemByName(rootObject,"MainForm");
    // Metódus meghívása
    QVariant returnedValue;
    QVariant messageText = "Stop parancs elküldve";
    QVariant color = "blue";
    qDebug() << "selectColor QML függvény meghívása...";
    QMetaObject::invokeMethod(mainForm, "selectColor",
    Q_RETURN_ARG(QVariant, returnedValue),
        Q_ARG(QVariant, messageText),
        Q_ARG(QVariant, color));
}

void MainWindowsEventHandling::resetCommand()
{
    robot.reset();
    auto mainForm = FindItemByName(rootObject,"MainForm");
    // Metódus meghívása
    QVariant returnedValue;
    QVariant messageText = "Reset parancs elküldve";
    QVariant color = "red";
    qDebug() << "selectColor QML függvény meghívása...";
    QMetaObject::invokeMethod(mainForm, "selectColor",
    Q_RETURN_ARG(QVariant, returnedValue),
        Q_ARG(QVariant, messageText),
        Q_ARG(QVariant, color));
}

void MainWindowsEventHandling::historyChanged()
{
    // Ahhoz, hogy frissüljenek a QML oldali adatok, frissíteni kell a változók összekapcsolását.
    qmlContext.setContextProperty(QStringLiteral("historyModel"), QVariant::fromValue(history.stateList));
    qmlContext.setContextProperty(QStringLiteral("currentState"), QVariant::fromValue(history.currentState));

    qmlContext.setContextProperty(QStringLiteral("historyGraphTimestamps"), QVariant::fromValue(history.graphTimestamps));
    qmlContext.setContextProperty(QStringLiteral("historyGraphVelocity"), QVariant::fromValue(history.graphVelocities));
    qmlContext.setContextProperty(QStringLiteral("historyGraphAcceleration"), QVariant::fromValue(history.graphAcceleration));

    // Jelzünk a QML controloknak, hogy újrarajzolhatják magukat, beállítottuk az új értékeket.
    emit historyContextUpdated();
}

void MainWindowsEventHandling::lineChanged()
{
    QVector<float> sensor = history.currentState->linesensor();
    for(int i=0;i<16;i++)
    {
        //qDebug() << sensor[i];
        if(sensor[i] > 2)
        {
            QObject *rect = rootObject->findChild<QObject*>("rect"+QString::number(i));
            if (rect)
                rect->setProperty("color", "red");
        }
        else
        {
            QObject *rect = rootObject->findChild<QObject*>("rect"+QString::number(i));
            if (rect)
                rect->setProperty("color", "white");
        }

    }
}

QQuickItem* MainWindowsEventHandling::FindItemByName(QList<QObject*> nodes, const QString& name)
{
    for(int i = 0; i < nodes.size(); i++)
    {
        // Node keresése
        if (nodes.at(i) && nodes.at(i)->objectName() == name)
        {
            return dynamic_cast<QQuickItem*>(nodes.at(i));
        }
        // Gyerekekben keresés
        else if (nodes.at(i) && nodes.at(i)->children().size() > 0)
        {
            QQuickItem* item = FindItemByName(nodes.at(i)->children(), name);
            if (item)
                return item;
        }
    }
    // Nem találtuk.
    return nullptr;
}

QQuickItem* MainWindowsEventHandling::FindItemByName(QObject *rootObject, const QString& name)
{
    return FindItemByName(rootObject->children(), name);
}

void MainWindowsEventHandling::ConnectQmlSignals(QObject *rootObject)
{
    QQuickItem *historyGraph = FindItemByName(rootObject,QString("historyGraph"));
    if (historyGraph)
    {
        QObject::connect(this, SIGNAL(historyContextUpdated()), historyGraph, SLOT(requestPaint()));
    }
    else
    {
        qDebug() << "HIBA: Nem találom a historyGraph objektumot a QML környezetben.";
    }
}
