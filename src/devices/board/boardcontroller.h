// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef BOARDCONTROLLER_H
#define BOARDCONTROLLER_H

#include <QObject>
#include <QQmlEngine>

#include "domain/dto/screen.h"

class BoardTransaction;

class BoardController : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(Screen buffer READ buffer WRITE setBuffer NOTIFY bufferChanged)

explicit BoardController(QObject* parent = nullptr)
    : QObject(parent)
{
}
public:
    BoardController(const BoardController&) = delete;
    BoardController(BoardController&&)      = delete;

    BoardController& operator=(const BoardController&) = delete;
    BoardController& operator=(BoardController&&)      = delete;

    static BoardController *create(QQmlEngine *, QJSEngine *);

    static BoardController& instance()
    {
        static BoardController* inst = new BoardController;
        return *inst;
    }

    bool enabled() const;
    void setEnabled(bool enabled);

    bool connected() const;

    Screen buffer() const;
    void setBuffer(const Screen &screen);

    Q_INVOKABLE void clearScreen();
    Q_INVOKABLE void sendBuffer();
    Q_INVOKABLE void powerOff();

signals:
    void enabledChanged();
    void connectedChanged();
    void bufferChanged();

    void transmissionFailed(const QString &error);
    void transmissionFinished();

private:
    void startTransmission(const Screen &screen);
    void cancelTransmission();

    void onTransactionFinished();
    void onTransactionFailed(const QString &error);
    void onPowerOffFinished();

    bool m_enabled = false;
    bool m_connected = false;

    Screen m_buffer;

    BoardTransaction *m_transaction = nullptr;

    inline static QJSEngine *s_engine = nullptr;
};

#endif // BOARDCONTROLLER_H
