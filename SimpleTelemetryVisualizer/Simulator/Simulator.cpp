#include <QTime>
#include <QtGlobal>
#include "Simulator.h"

Simulator::Simulator(int port)
    : communication(port), state()
{
    // Fogadni akarjuk a parancsokat
    connect(&communication, SIGNAL(dataReady(QDataStream&)), this, SLOT(dataReady(QDataStream&)));
    // Periodikusan futnia kell a szimulációnak
    connect(&timer, SIGNAL(timeout()), this, SLOT(tick()));
}

void Simulator::start(float intervalSec)
{
    //Szimulátor indítás
    QTime now = QTime::currentTime();
    qsrand(now.second());
    dt = intervalSec;
    state.setStatus(RobotState::Status::Default);
    state.setTimestamp(0);
    state.setX(0.0F);
    state.setV(0.0F);
    state.setA(0.0F);
    state.setLight(0);
    state.setIndex(qrand() % 15);
    timer.start((long)(intervalSec*1000.0F));
}

void Simulator::tick()
{
    // Fizikai szimuláció
    state.setTimestamp(state.timestamp() + dt);
    state.setX(state.x() + state.v()*dt);
    state.setV(state.v() + state.a()*dt);
    if(state.v() != 0.0F)
    {
        int newIndex = state.index() + (qrand() % 3) - 1;
        if (newIndex < 0)
          newIndex = 0;
        else if (newIndex > 14)
          newIndex = 14;
        state.setIndex(newIndex);
    }
    else
    {
        state.setIndex(state.index());
    }

    if (state.v()<-15.0)
    {
        state.setV( -15.0F );
        state.setStatus(RobotState::Status::Constant);
    }
    if (state.v()>15.0)
    {
        state.setV( 15.0F );
        state.setStatus(RobotState::Status::Constant);
    }

    state.setLight( state.v()>=10.0F ? 1.0F : 0.0F );

    // Magasabb szintű funkciók
    switch(state.status())
    {
    case RobotState::Status::Default:
        break;
    case RobotState::Status::Reset:
        qDebug() << "Simulator: Reset";
        state.setStatus(RobotState::Status::Default);
        state.setX(0.0F);
        state.setV(0.0F);
        state.setA(0.0F);
        state.setLight(0);
        break;
    case RobotState::Status::Stopping:
         state.setStatus(RobotState::Status::Stopping);
        if (state.v() > 1.5F)
        {
            qDebug() << "Simulator: Stop parancs, gyors lassítás";
            state.setA(-1.0F);
        }
        else if (state.v() > 0.2F)
        {
            qDebug() << "Simulator: Stop parancs, lassú lassítás";
            state.setA(-0.2F);
        }
        else if (state.v() < -1.5F)
        {
            qDebug() << "Simulator: Stop parancs, gyorsítás előre";
            state.setA(1.0F);
        }
        else if (state.v() < -0.2F)
        {
            qDebug() << "Simulator: Stop parancs, lassú gyorsítás előre";
            state.setA(0.2F);
        }
        else
        {
            // Majdnem megállt
            qDebug() << "Simulator: Megállt.";
            state.setStatus(RobotState::Status::Default);
            state.setV(0.0F);
            state.setA(0.0F);
        }
        break;
    case RobotState::Status::Accelerate:
        break;
    case RobotState::Status::Reverse:
        break;
    case RobotState::Status::Constant:
        state.setA(0.0F);
        break;
    default:
        Q_UNREACHABLE();
    }

    qDebug() << "Simulator: tick (" << state.timestamp()
             << "): állapot=" << state.getStatusName()
             << ", x=" << state.x()
             << ", v=" << state.v()
             << ", a=" << state.a()
             << ", lámpa:" << state.light();

    // Állapot küldése
    if (communication.isConnected())
    {
        communication.send(state);
    }
}

void Simulator::dataReady(QDataStream &inputStream)
{
    RobotState receivedState;
    receivedState.ReadFrom(inputStream);

    switch(receivedState.status())
    {
    case RobotState::Status::Default:
        qDebug() << "Simulator: OK parancs. Igen, minden OK, köszönöm!";
        break;
    case RobotState::Status::Reset:
        qDebug() << "Simulator: Reset parancs.";
        state.setStatus(RobotState::Status::Reset);
        break;
    case RobotState::Status::Stopping:
        qDebug() << "Simulator: Stop parancs.";
        state.setStatus(RobotState::Status::Stopping);
        break;
    case RobotState::Status::Accelerate:
        qDebug() << "Simulator: Gyorsítási parancs.";
        state.setStatus(RobotState::Status::Accelerate);
        state.setA(receivedState.a());
        break;
    case RobotState::Status::Reverse:
        qDebug() << "Simulator: Gyorsítási parancs.";
        state.setStatus(RobotState::Status::Reverse);
        state.setA(receivedState.a());
        break;
    default:
        Q_UNREACHABLE();
    }
}
