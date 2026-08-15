// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#include "boardcontroller.h"
#include "boardtransaction.h"
#include "boardcommandsession.h"

BoardController *BoardController::create(QQmlEngine *, QJSEngine *engine)
{
    // The instance has to exist before it is used. We cannot replace it.
    Q_ASSERT(&instance());

    // The engine has to have the same thread affinity as the singleton.
    Q_ASSERT(engine->thread() == instance().thread());

    // There can only be one engine accessing the singleton.
    if (s_engine)
        Q_ASSERT(engine == s_engine);
    else
        s_engine = engine;

    // Explicitly specify C++ ownership so that the engine doesn't delete
    // the instance.
    QJSEngine::setObjectOwnership(&instance(), QJSEngine::CppOwnership);

    return &instance();
}

bool BoardController::enabled() const
{
    return m_enabled;
}

void BoardController::setEnabled(bool enabled)
{
    if(m_enabled == enabled)
        return;

    m_enabled = enabled;
    emit enabledChanged();

    if(enabled)
    {
        startTransmission(m_buffer);
    }
    else
    {
        cancelTransmission();

        startTransmission(Screen::emptyScreen());
    }
}

bool BoardController::connected() const
{
    return m_connected;
}

Screen BoardController::buffer() const
{
    return m_buffer;
}

void BoardController::setBuffer(const Screen &screen)
{
    if(m_buffer == screen)
        return;

    m_buffer = screen;
    emit bufferChanged();

    if(m_enabled)
        startTransmission(m_buffer);
}

void BoardController::clearScreen()
{
    setBuffer(Screen::emptyScreen());
}

void BoardController::sendBuffer()
{
    startTransmission(m_buffer);
}

void BoardController::powerOff()
{
    cancelTransmission();

    BoardCommandSession *session = new BoardCommandSession(false, this);

    connect(session, &BoardCommandSession::finished, this, [this, session]() {
        m_connected = false;
        emit connectedChanged();
        session->deleteLater();
    });

    connect(session, &BoardCommandSession::failed, this, [this, session](){
        session->deleteLater();
    });

    session->start();
    session->send("qq0");
}

void BoardController::startTransmission(const Screen &screen)
{
    cancelTransmission();

    m_transaction = new BoardTransaction(screen, this);

    connect(m_transaction, &BoardTransaction::finished, this, &BoardController::onTransactionFinished);
    connect(m_transaction, &BoardTransaction::failed, this, &BoardController::onTransactionFailed);
    connect(m_transaction, &BoardTransaction::connectedChanged, this, [this](bool connected){
        if(m_connected == connected)
            return;

        m_connected = connected;
        emit connectedChanged();
    });

    m_transaction->start();

}

void BoardController::cancelTransmission()
{
    if(!m_transaction)
        return;

    m_transaction->cancel();
    m_transaction->deleteLater();
    m_transaction = nullptr;
}

void BoardController::onTransactionFinished()
{
    if(!m_transaction)
        return;

    m_transaction->deleteLater();
    m_transaction = nullptr;

    emit transmissionFinished();
}

void BoardController::onTransactionFailed(const QString &error)
{
    if(!m_transaction)
        return;

    m_transaction->deleteLater();
    m_transaction = nullptr;

    emit transmissionFailed(error);
}

void BoardController::onPowerOffFinished()
{
    m_connected = false;
    emit connectedChanged();
}
