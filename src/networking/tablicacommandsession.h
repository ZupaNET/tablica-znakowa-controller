// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef TABLICACOMMANDSESSION_H
#define TABLICACOMMANDSESSION_H

#include <QObject>
#include <QTcpSocket>
#include <QHostAddress>

class TablicaCommandSession : public QObject
{
    Q_OBJECT

public:

    explicit TablicaCommandSession(const QString& address, quint16 port, const QString& command, QObject *parent = nullptr);

    void start();

signals:
    void finished(bool success);

private slots:
    void connected();
    void readyRead();
    void error(QAbstractSocket::SocketError);

private:
    QTcpSocket *socket;

    QHostAddress address;
    quint16 port;

    QString command;
};

#endif // TABLICACOMMANDSESSION_H
