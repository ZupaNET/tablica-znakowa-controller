// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef TABLICACONNECTOR_H
#define TABLICACONNECTOR_H

#include <QObject>
#include <QtQml/QtQml>

#include "core/dto/screen.h"

class TablicaConnector : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT

    Q_PROPERTY(Screen buffer        READ getBuffer      WRITE setBuffer     NOTIFY bufferChanged)
    Q_PROPERTY(bool enabled         READ getEnabled     WRITE setEnabled    NOTIFY enabledChanged)
    Q_PROPERTY(QString ipAddress    READ getIpAddress   WRITE setIpAddress  NOTIFY ipAddressChanged)
    Q_PROPERTY(quint16 port         READ getPort        WRITE setPort       NOTIFY portChanged)

explicit TablicaConnector(QObject* parent = nullptr)
    : QObject(parent)
{
}
public:
    TablicaConnector(const TablicaConnector&) = delete;
    TablicaConnector(TablicaConnector&&)      = delete;

    TablicaConnector& operator=(const TablicaConnector&) = delete;
    TablicaConnector& operator=(TablicaConnector&&)      = delete;

    static TablicaConnector *create(QQmlEngine *, QJSEngine *);

    static TablicaConnector& instance()
    {
        static TablicaConnector* inst = new TablicaConnector;
        inst->init();
        return *inst;
    }

private:
    bool m_initialized = false;

    Screen buffer = Screen::emptyScreen();
    bool enabled = false;

    QString ipAddress = "192.168.0.100";
    quint16 port = 60023;
    quint8 brightness = 2;
    quint8 font = 2;

    QQueue<QString> commandQueue;
    bool commandRunning = false;
    QTimer connectionCooldown;
    bool connectionBlocked = false;

    void init();

    void setBrightness(quint8 brightness);
    void setFont(quint8 font);

    bool sendScreen(const Screen& scr);
    bool sendLine(const QString& line, quint8 lineNumber);
    bool display();

    bool submitCommand();
    bool sendCommand(const QString& command);
    void processQueue();

    inline static QJSEngine *s_engine = nullptr;

signals:
    void bufferChanged();
    void enabledChanged();
    void ipAddressChanged();
    void portChanged();

    void connectionFailure();
    void commandQueueEmpty();
public:
    void setBuffer(const Screen& buffer);
    Screen getBuffer();

    void setEnabled(bool state);
    bool getEnabled();

    QString getIpAddress() const;

    quint16 getPort();

    Q_INVOKABLE bool shutdown();

    Q_INVOKABLE bool testDisplay(quint8 testNumber);
    Q_INVOKABLE bool testStop();

    Q_INVOKABLE void resendBuffer();
    Q_INVOKABLE bool clearScreen();

public slots:
    void setBrightnessNow(quint8 brightness);
    void setIpAddress(const QString& ipAddress);
    void setPort(quint16 port);

};

#endif // TABLICACONNECTOR_H
