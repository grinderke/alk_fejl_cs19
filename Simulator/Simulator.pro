CONFIG += c++14
QMAKE_CXXFLAGS_CXX11    = -std=c++1y

TEMPLATE = app

QT += qml quick widgets
# greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport

SOURCES += main.cpp \
    Application.cpp \
    SocketClient.cpp \
    SocketServer.cpp \
    MainApp.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    Application.h \
    SocketClient.h \
    SocketServer.h \
    MainApp.h
