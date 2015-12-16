#include "RobotProxy.h"
#include "RobotStateHistory.h"
#include "Communication/Communication.h"
#include "RobotState.h"

RobotProxy::RobotProxy(RobotStateHistory& history, Communication &communication)
    : history(history), communication(communication)
{
    // Jelzést kérünk, ha új robot állapot (RobotState) érkezik.
    QObject::connect(&communication, SIGNAL(dataReady(QDataStream&)), this, SLOT(dataReady(QDataStream&)));
}

void RobotProxy::dataReady(QDataStream &stream)
{
    // Új robot állapot érkezett, elmentjük a historyba.
    //  (Onnan vesszük majd azt is, hogy mi az aktuális állapot.)
    RobotState state;
    state.ReadFrom(stream);
    history.Add(state);
}

void RobotProxy::reset()
{
    // Reset parancs küldése.
    RobotState newState;
    newState.setStatus(RobotState::Status::Reset);
    communication.send(newState);
    qDebug() << "Reset parancs elküldve.";
}

void RobotProxy::accelerate()
{
    RobotState newState;
    newState.setA(acceleration);
    if(acceleration >0)
        newState.setStatus(RobotState::Status::Accelerate);
    else
        newState.setStatus(RobotState::Status::Reverse);
    communication.send(newState);
    qDebug() << "Gyorsítási parancs elküldve.";
}

void RobotProxy::stop()
{
    RobotState newState;
    newState.setStatus(RobotState::Status::Stopping);
    communication.send(newState);
    qDebug() << "Stop parancs elküldve.";
}
