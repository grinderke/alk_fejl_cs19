#pragma once
#ifndef MAINAPP_H
#define MAINAPP_H
#include <QObject>
#include <QQuickItem>

class MainApp : public QObject
{
    Q_OBJECT

public:
    MainApp(QObject *rootObject);
    ~MainApp() = default;

public slots:
    /** Eseménykezelő a QML oldali addGreenEntry signalhoz. */
    void socketConnectHandler();

private:
    QQuickItem* findItemByName(const QString& name);
    QQuickItem* findItemByName(QObject *rootObject, const QString& name);
    QQuickItem* findItemByName(QList<QObject*> nodes, const QString& name);
    QQuickItem* mainAppObject;
};

#endif // MAINAPP_H
