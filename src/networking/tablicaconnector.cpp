#include "tablicaconnector.h"
#include <QDebug>
#include "tablicacommandsession.h"

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
    QJSEngine::setObjectOwnership(&instance(),
                                  QJSEngine::CppOwnership);
    return &instance();
}

void TablicaConnector::init()
{
    if (m_initialized)
        return;

    this->appSettings = &AppSettings::instance();

    this->ipAddress = QHostAddress(appSettings->ipAddress());
    this->port = appSettings->port();
    this->brightness = appSettings->brightness();

    connectionCooldown.setSingleShot(true);
    connect(&connectionCooldown, &QTimer::timeout, this, [this]() { connectionBlocked = false; });

    connect(appSettings, &AppSettings::ipAddressChanged, this, &TablicaConnector::setIpAddress);
    connect(appSettings, &AppSettings::portChanged, this, &TablicaConnector::setPort);
    connect(appSettings, &AppSettings::brightnessChanged, this, &TablicaConnector::setBrightnessNow);

    m_initialized = true;
}

void TablicaConnector::setBuffer(const Screen& buffer){
    if(this->buffer == buffer){
        return;
    }
    this->buffer = buffer;
    emit bufferChanged();

    sendScreen(buffer);
}

Screen TablicaConnector::getBuffer(){
    return buffer;
}

void TablicaConnector::setEnabled(bool state){
    if(enabled == state){
        return;
    }

    if(state == true)
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

bool TablicaConnector::isEnabled(){
    return enabled;
}

void TablicaConnector::setIpAddress(QString ipAddress){
    if(this->ipAddress == QHostAddress(ipAddress)){
        return;
    }

    this->ipAddress = QHostAddress(ipAddress);
    emit ipAddressChanged();
    qDebug()<<"Zmieniono adres IP: " << this->ipAddress;
}

QString TablicaConnector::getIpAddress(){
    return ipAddress.toString();
}

void TablicaConnector::setPort(quint16 port){
    if(this->port == port){
        return;
    }

    this->port = port;
    emit portChanged();
}

quint16 TablicaConnector::getPort(){
    return port;
}

void TablicaConnector::setBrightness(quint8 brightness){
    this->brightness = brightness;
    sendCommand("j0"+QString::number(brightness));
}

void TablicaConnector::setBrightnessNow(quint8 brightness){
    setBrightness(brightness);
    submitCommand();
}


void TablicaConnector::setFont(quint8 font){
    this->font = font;
    sendCommand("f0"+QString::number(font));
}

bool TablicaConnector::sendScreen(const Screen& scr) {
    if(!enabled) return false;
    QString normalized = scr.text;
    normalized.replace("\r\n", "\n");
    normalized.replace('\r', '\n');

    QStringList lines = normalized.split('\n');
    for(int i = 0; i < 12; i++)
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

bool TablicaConnector::sendLine(QString line, quint8 lineNumber){
    QString command = "l"+QString::number(lineNumber).rightJustified(2, '0', true)+line+"";
    return sendCommand(command+'\0');
}

bool TablicaConnector::display(){
    if(!enabled) return false;
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

bool TablicaConnector::sendCommand(QString command)
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


    QString cmd =
        commandQueue.dequeue();


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

// bool TablicaConnector::sendCommand(QString command){
//     QTcpSocket socket;
//     socket.connectToHost(ipAddress, port);

//     if(!socket.waitForConnected(150))
//     {
//         emit connectionFailure();
//         return false;
//     }

//     if(!socket.isOpen())
//     {
//         emit connectionFailure();
//         return false;
//     }

//     QString packet = command+'\n';

//     if(socket.write(packet.toUtf8()) == -1)
//     {
//         emit connectionFailure();
//         return false;
//     }

//     if(!socket.waitForBytesWritten(150))
//     {
//         emit connectionFailure();
//         return false;
//     }

//     if(socket.waitForReadyRead(150))
//     {
//         QByteArray response =
//             socket.readAll();
//         if(!(response == "ok\n"))
//         {
//             emit connectionFailure();
//             return false;
//         }
//     }

//     socket.disconnectFromHost();

//     if(socket.state() != QAbstractSocket::UnconnectedState)
//     {
//         socket.waitForDisconnected(150);
//     }
//     return true;
// }