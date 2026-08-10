// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "tablicaconnector.h"

#include "tablicacommandsession.h"
#include "settings/appsettings.h"

TablicaConnector *TablicaConnector::create(QQmlEngine *, QJSEngine *engine)
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

void TablicaConnector::init()
{
    if (m_initialized)
        return;

    this->ipAddress = AppSettings::instance().ipAddress();
    this->port = AppSettings::instance().port();
    this->brightness = AppSettings::instance().brightness();

    connectionCooldown.setSingleShot(true);
    connect(&connectionCooldown, &QTimer::timeout, this, [this]() { connectionBlocked = false; });

    connect(&AppSettings::instance(), &AppSettings::ipAddressChanged,   this, &TablicaConnector::setIpAddress);
    connect(&AppSettings::instance(), &AppSettings::portChanged,        this, &TablicaConnector::setPort);
    connect(&AppSettings::instance(), &AppSettings::brightnessChanged,  this, &TablicaConnector::setBrightnessNow);

    m_initialized = true;
}

void TablicaConnector::setBuffer(const Screen& buffer)
{
    if(this->buffer == buffer)
        return;

    this->buffer = buffer;
    emit bufferChanged();

    sendScreen(buffer);
}

Screen TablicaConnector::getBuffer()
{
    return buffer;
}

void TablicaConnector::setEnabled(bool state)
{
    if(enabled == state)
        return;

    if(state)
    {
        enabled = state;
        sendScreen(buffer);
    }
    else
    {
        clearScreen();
        enabled = state;
    }

    emit enabledChanged();
}

bool TablicaConnector::getEnabled()
{
    return enabled;
}

void TablicaConnector::setIpAddress(const QString& ipAddress){
    if(this->ipAddress == ipAddress)
        return;

    this->ipAddress = ipAddress;

    emit ipAddressChanged();
}

QString TablicaConnector::getIpAddress() const
{
    return ipAddress;
}

void TablicaConnector::setPort(quint16 port)
{
    if(this->port == port)
        return;

    this->port = port;

    emit portChanged();
}

quint16 TablicaConnector::getPort()
{
    return port;
}

void TablicaConnector::setBrightness(quint8 brightness)
{
    this->brightness = brightness;

    sendCommand("j0"+QString::number(brightness));
}

void TablicaConnector::setBrightnessNow(quint8 brightness)
{
    setBrightness(brightness);
    submitCommand();
}


void TablicaConnector::setFont(quint8 font)
{
    this->font = font;

    sendCommand("f0"+QString::number(font));
}

bool TablicaConnector::sendScreen(const Screen& scr)
{
    if(!enabled) return false;

    QString normalized = scr.text;
    normalized.replace("\r\n", "\n");
    normalized.replace('\r', '\n');

    QStringList lines = normalized.split('\n');
    for(int i = 0; i < 14; i++)
    {
        QString line = " ";

        if(i < lines.size())
            line = lines.at(i) + line;

        if(!sendLine(line,i)) return false;
    }

    setFont(scr.font);

    if(!display()) return false;

    setBrightness(brightness);

    if(!submitCommand()) return false;

    return true;
}

bool TablicaConnector::clearScreen()
{
    auto emptyScreen = Screen::emptyScreen();

    return sendScreen(emptyScreen);
}

void TablicaConnector::resendBuffer()
{
    sendScreen(buffer);
}

bool TablicaConnector::sendLine(const QString& line, quint8 lineNumber)
{
    QString command = "l"+QString::number(lineNumber).rightJustified(2, '0', true)+line+"";
    return sendCommand(command+'\0');
}

bool TablicaConnector::display()
{
    if(!enabled)
        return false;

    return sendCommand("go0");
}

bool TablicaConnector::shutdown()
{
    return sendCommand("qq0");
}

bool TablicaConnector::testDisplay(quint8 testNumber)
{
    return sendCommand("t0"+QString::number(testNumber));
}

bool TablicaConnector::testStop()
{
    return sendCommand("t03");
}

bool TablicaConnector::submitCommand()
{
    return sendCommand("wy0");
}

bool TablicaConnector::sendCommand(const QString& command)
{
    if (connectionBlocked)
        return false;

    commandQueue.enqueue(command);

    processQueue();

    return true;
}

void TablicaConnector::processQueue()
{
    if(commandRunning)
        return;

    if (commandQueue.isEmpty()) {
        emit commandQueueEmpty();
        return;
    }

    commandRunning = true;

    QString cmd = commandQueue.dequeue();


    TablicaCommandSession *session = new TablicaCommandSession(ipAddress, port, cmd, this);

    connect(session,
            &TablicaCommandSession::finished,
            this,
            [this](bool ok)
            {
                commandRunning = false;

                if (!ok) {
                    commandQueue.clear();

                    connectionBlocked = true;
                    connectionCooldown.start(2000);

                    emit connectionFailure();
                    return;
                }

                processQueue();
            });


    session->start();
}
