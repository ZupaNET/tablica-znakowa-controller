#ifndef TABLICACONNECTOR_H
#define TABLICACONNECTOR_H

#include <QObject>
#include <QHostAddress>
#include <QTcpSocket>
#include <QAbstractSocket>
#include "models/dto.h"

class TablicaConnector
:public QObject
{
    Q_OBJECT
public:
    TablicaConnector(QObject* parent = nullptr);

private:
    bool frozen = false;
    QHostAddress ipAddress = QHostAddress("192.168.0.100");
    quint16 port = 60023;
    quint8 brightness = 2;
    quint8 font = 1;

    QTcpSocket* client;

    bool submitCommand();
    bool sendCommand(QString command);

signals:
    void connected();
    void disconnected();

public slots:
    void setFreeze(bool state);
    bool isFrozen();

    void setIpAddress(QString ipAddress);
    void setPort(quint16 port);
    void setBrightness(quint8 brightness);
    void setFont(quint8 font);

    bool sendScreen(Screen &scr);
    bool sendLine(QString line, quint8 lineNumber);
    bool display();
    bool shutdown();

    bool testDisplay(quint8 testNumber);
    bool testStop();
};

#endif // TABLICACONNECTOR_H
