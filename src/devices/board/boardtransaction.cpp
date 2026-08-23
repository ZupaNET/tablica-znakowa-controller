// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#include "boardtransaction.h"
#include "boardcommandsession.h"
#include "settings/appsettings.h"

BoardTransaction::BoardTransaction(const Screen& screen, QObject *parent)
    : QObject{parent}
    , m_screen{screen}
{
    m_singleConnection = AppSettings::instance().singleConnection();
    m_commands = {};

    // Build the line commands
    QString normalized = screen.text;
    normalized.replace("\r\n", "\n");

    QStringList lines = normalized.split("\n");
    for(int i = 0; i < 14; i++)
    {
        QString line = " ";
        QString lineNumber = QString::number(i).rightJustified(2, '0', true);

        if (i < lines.size())
            line = lines.at(i) + line;

        m_commands.append("l" + lineNumber + line + "" + '\0');
    }

    // Change font
    m_commands.append("f" + QString::number(screen.font).rightJustified(2, '0', true));

    // Append the go command
    m_commands.append("go0");

    // Append the brightness command
    m_commands.append("j" + QString::number(AppSettings::instance().brightness()).rightJustified(2, '0', true));

    // Append the wy command
    m_commands.append("wy0");
}

void BoardTransaction::start()
{
    m_cancelled = false;
    m_commandIndex = 0;

    if(m_singleConnection)
    {
        m_session = new BoardCommandSession(true, this);

        connect(m_session, &BoardCommandSession::finished, this, &BoardTransaction::commandFinished);
        connect(m_session, &BoardCommandSession::failed, this, &BoardTransaction::commandFailed);
        connect(m_session, &BoardCommandSession::connectedChanged, this, &BoardTransaction::connectedChanged);
        connect(m_session, &BoardCommandSession::connectedChanged, this, [this](bool connected) {
            if (connected)
                next();
        });

        m_session->start();
        return;
    }

    next();
}

void BoardTransaction::cancel()
{
    if (m_cancelled)
        return;

    m_cancelled = true;

    if(m_session)
    {
        m_session->cancel();
        m_session->deleteLater();
        m_session = nullptr;
    }
}

void BoardTransaction::next()
{
    if(m_cancelled)
        return;

    if(m_commandIndex >= m_commands.size())
    {
        emit finished();
        return;
    }

    startCommand();
}

void BoardTransaction::startCommand()
{
    if(m_cancelled)
        return;

    const QString command = m_commands[m_commandIndex];

    if(m_singleConnection)
    {
        m_session->send(command);
        return;
    }

    m_session = new BoardCommandSession(false, this);

    connect(m_session, &BoardCommandSession::finished, this, &BoardTransaction::commandFinished);
    connect(m_session, &BoardCommandSession::failed, this, &BoardTransaction::commandFailed);
    connect(m_session, &BoardCommandSession::connectedChanged, this, &BoardTransaction::connectedChanged);

    m_session->start();
    if(m_session != nullptr)
        m_session->send(command);
}

void BoardTransaction::commandFinished()
{
    if(m_cancelled)
        return;

    m_commandIndex++;

    if(m_commandIndex >= m_commands.size())
    {
        if(m_session)
        {
            m_session->deleteLater();
            m_session = nullptr;
        }

        emit finished();
        return;
    }

    if(m_singleConnection)
    {
        next();
        return;
    }

    if(m_session)
    {
        m_session->deleteLater();
        m_session = nullptr;
    }

    next();
}

void BoardTransaction::commandFailed(const QString &error)
{
    if(m_cancelled)
        return;

    m_session->deleteLater();
    m_session = nullptr;

    emit failed(error);
}