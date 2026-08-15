// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#include "boardcommandsession.h"
#include "settings/appsettings.h"

BoardCommandSession::BoardCommandSession(bool keepConnection, QObject *parent)
    : QObject{parent}
    , m_socket{new QTcpSocket(this)}
    , m_keepConnection{keepConnection}
    , m_connectTimer{new QTimer(this)}
{
    m_connectTimer->setSingleShot(true);

    connect(m_socket, &QTcpSocket::connected, this, &BoardCommandSession::onConnected);
    connect(m_socket, &QTcpSocket::readyRead, this, &BoardCommandSession::onReadyRead);
    connect(m_socket, &QTcpSocket::errorOccurred, this, &BoardCommandSession::onError);
    connect(m_socket, &QTcpSocket::connected, this, [this]{ emit connectedChanged(true); });
    connect(m_socket, &QTcpSocket::disconnected, this, [this]{ emit connectedChanged(false); });

    connect(m_connectTimer, &QTimer::timeout, this, [this] {
        m_socket->abort();
        emit failed(tr("przekroczono limit czasu połączenia"));
    });
}


void BoardCommandSession::start()
{
    m_socket->connectToHost(AppSettings::instance().ipAddress(), AppSettings::instance().port());
    m_connectTimer->start(2000);
}

void BoardCommandSession::send(const QString &command)
{
    m_command = command;

    if (m_socket->state() == QAbstractSocket::ConnectedState)
        onConnected();
}

void BoardCommandSession::cancel()
{
    m_socket->abort();
}

void BoardCommandSession::onConnected()
{
    m_connectTimer->stop();

    m_socket->setSocketOption(QAbstractSocket::LowDelayOption, 1);
    m_socket->write((m_command + "\n").toUtf8());
    m_socket->flush();

    m_command.clear();
}


void BoardCommandSession::onReadyRead()
{
    if(m_socket->bytesAvailable() < 3)
        return;

    QByteArray response = m_socket->readAll();

    if(response == "ok\n")
    {
        emit finished();

        if(!m_keepConnection)
            m_socket->disconnectFromHost();
    }
    else
    {
        emit failed(tr("polecenie zostało odrzucone"));
        m_socket->abort();
    }
}


void BoardCommandSession::onError(QAbstractSocket::SocketError)
{
    emit failed(m_socket->errorString());
}