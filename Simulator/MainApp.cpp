#include <QQmlProperty>
#include "MainApp.h"

MainApp::MainApp(QObject *rootObject)
    : QObject(nullptr)
{
    if (!rootObject)
    {
        qDebug() << "Nem találom a rootObject-et.";
    }

    mainAppObject = findItemByName(rootObject, QString("MainWindow"));

    if (!mainAppObject)
    {
        qDebug() << "Nem találom az MainApp objektumot.";
    }

    qDebug() << "QML signal csatlakoztatása";
    QObject::connect(mainAppObject, SIGNAL(socketConnect()), this, SLOT(socketConnectHandler()));

    qDebug() << "MainApp inicializálva.";
}

void MainApp::socketConnectHandler()
{
    qDebug() << "MainApp::socketConnectHandler()";
    auto mainWindow = findItemByName("MainWindow");
    // Metódus meghívása

    QVariant returnedValue;
    QVariant messageText = "Socket kapcsolat létrejött";
    qDebug() << "selectColor QML függvény meghívása...";
    QVariant color = "green";
    QMetaObject::invokeMethod(mainWindow, "socketConnection",
        Q_RETURN_ARG(QVariant, returnedValue),
        Q_ARG(QVariant, messageText),
        Q_ARG(QVariant, color));
}

QQuickItem* MainApp::findItemByName(const QString& name)
{
    Q_ASSERT(mainAppObject != nullptr);
    if (mainAppObject->objectName() == name)
    {
        return mainAppObject;
    }
    return findItemByName(mainAppObject->children(), name);
}

QQuickItem* MainApp::findItemByName(QObject *rootObject, const QString& name)
{
    Q_ASSERT(rootObject != nullptr);
    if (rootObject->objectName() == name)
    {
        return (QQuickItem*)rootObject;
    }
    return findItemByName(rootObject->children(), name);
}

QQuickItem* MainApp::findItemByName(QList<QObject*> nodes, const QString& name)
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
            QQuickItem* item = findItemByName(nodes.at(i)->children(), name);
            if (item)
                return item;
        }
    }
    // Nem találtuk.
    return nullptr;
}
