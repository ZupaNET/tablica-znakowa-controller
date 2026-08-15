// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef BOARDCOMMANDSESSION_H
#define BOARDCOMMANDSESSION_H

#include <QObject>
#include <QTcpSocket>
#include <QTimer>

class BoardCommandSession : public QObject
{
    Q_OBJECT
public:
    explicit BoardCommandSession(bool keepConnection = false, QObject *parent = nullptr);

    void start();
    void send(const QString &command);
    void cancel();

signals:
    void finished();
    void failed(const QString &error);

    void connectedChanged(bool connected);

private slots:
    void onConnected();
    void onReadyRead();
    void onError(QAbstractSocket::SocketError error);

private:
    QString m_command;
    QTcpSocket *m_socket = nullptr;
    QTimer *m_connectTimer = nullptr;

    bool m_keepConnection = false;
};

#endif // BOARDCOMMANDSESSION_H
