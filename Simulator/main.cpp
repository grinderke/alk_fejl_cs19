#include <QApplication>
#include <QQmlApplicationEngine>
#include "MainApp.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    MainApp mainApp(engine.rootObjects()[0]);
    Q_UNUSED(mainApp);

    return app.exec();
}
