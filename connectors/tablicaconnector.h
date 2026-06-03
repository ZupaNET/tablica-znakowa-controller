#ifndef TABLICACONNECTOR_H
#define TABLICACONNECTOR_H

#include <QObject>
#include <QHostAddress>
#include <QTcpSocket>
#include <QAbstractSocket>
#include "models/dto.h"

class TablicaConnector : public QObject
{
    Q_OBJECT

    Q_PROPERTY(Screen buffer
                READ getBuffer
                WRITE setBuffer
                NOTIFY bufferChanged
               )

    Q_PROPERTY(bool enabled
                READ isEnabled
                WRITE setEnabled
                NOTIFY enabledChanged
                )

    Q_PROPERTY(QString ipAddress
                READ getIpAddress
                WRITE setIpAddress
                NOTIFY ipAddressChanged
               )

    Q_PROPERTY(quint16 port
                READ getPort
                WRITE setPort
                NOTIFY portChanged
               )

public:
    TablicaConnector(QObject* parent = nullptr);

    ~TablicaConnector();

private:
    Screen buffer;
    bool enabled = false;
    //QHostAddress ipAddress = QHostAddress("192.168.0.100");
    QHostAddress ipAddress = QHostAddress("192.168.10.146");
    quint16 port = 60023;
    quint8 brightness = 2;
    quint8 font = 1;

    QTcpSocket* client;

    void setBrightness(quint8 brightness);
    void setFont(quint8 font);

    bool sendScreen(const Screen& scr);
    bool sendLine(QString line, quint8 lineNumber);
    bool display();

    bool submitCommand();
    bool sendCommand(QString command);

signals:
    void connected();
    void disconnected();

    void bufferChanged();
    void enabledChanged();
    void ipAddressChanged();
    void portChanged();

public:
    void setBuffer(const Screen& buffer);
    Screen getBuffer();

    void setEnabled(bool state);
    bool isEnabled();

    void setIpAddress(QString ipAddress);
    QString getIpAddress();

    void setPort(quint16 port);
    quint16 getPort();

    Q_INVOKABLE bool shutdown();

    Q_INVOKABLE bool testDisplay(quint8 testNumber);
    Q_INVOKABLE bool testStop();
};

#endif // TABLICACONNECTOR_H
