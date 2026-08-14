// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "tablicacommandsession.h"

TablicaCommandSession::TablicaCommandSession(const QString& address, quint16 port, const QString& command, QObject *parent)
    :
    QObject(parent),
    address(address),
    port(port),
    command(command)
{
}


void TablicaCommandSession::start()
{
    socket = new QTcpSocket(this);

    connect(socket, &QTcpSocket::connected, this, &TablicaCommandSession::connected);
    connect(socket, &QTcpSocket::readyRead, this, &TablicaCommandSession::readyRead);
    connect(socket, &QTcpSocket::errorOccurred, this, &TablicaCommandSession::error);

    socket->connectToHost(address, port);
}


void TablicaCommandSession::connected()
{
    socket->write((command + "\n").toUtf8());
}


void TablicaCommandSession::readyRead()
{
    QByteArray response =
        socket->readAll();

    emit finished(response == "ok\n");

    socket->disconnectFromHost();

    deleteLater();
}


void TablicaCommandSession::error(QAbstractSocket::SocketError)
{
    emit finished(false);

    deleteLater();
}