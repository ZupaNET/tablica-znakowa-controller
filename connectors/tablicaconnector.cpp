#include "tablicaconnector.h"
#include <QDebug>

TablicaConnector::TablicaConnector(QObject* parent)
    : client(new QTcpSocket(this)){}


void TablicaConnector::setFreeze(bool state){
    frozen = state;
    qDebug()<<state;
}

bool TablicaConnector::isFrozen(){
    return frozen;
}

void TablicaConnector::setIpAddress(QString ipAddress){
    this->ipAddress = QHostAddress(ipAddress);
}

void TablicaConnector::setPort(quint16 port){
    this->port = port;
}

void TablicaConnector::setBrightness(quint8 brightness){
    this->brightness = brightness;
    sendCommand("j0"+QString::number(brightness));
    submitCommand();
}

void TablicaConnector::setFont(quint8 font){
    this->font = font;
    sendCommand("f0"+QString::number(font));
}

bool TablicaConnector::sendLine(QString line, quint8 lineNumber){
    QString command = "l"+QString::number(lineNumber).rightJustified(2, '0', true)+line+" ";
    return sendCommand(command);
}

bool TablicaConnector::display(){
    if(frozen) return false;
    return sendCommand("go0");
}

bool TablicaConnector::shutdown(){
    return sendCommand("qq0");
}

bool TablicaConnector::testDisplay(quint8 testNumber){
    return sendCommand("t0"+QString::number(testNumber));
}

bool TablicaConnector::testStop(){
    return sendCommand("t03");
}

bool TablicaConnector::submitCommand(){
    return sendCommand("wy0");
}

bool TablicaConnector::sendCommand(QString command){
    client->connectToHost(ipAddress, port);
    client->waitForConnected(1000);
    if(client->isOpen()){
        QString packet = command+"\n";
        client->write(packet.toUtf8());
        client->disconnect();
        return true;
    }else{
        return false;
    }
}