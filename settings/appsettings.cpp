#include "appsettings.h"

AppSettings::AppSettings(QObject *parent)
    : QObject(parent)
{
    m_screenView = m_settings.value(
                                 "screenView",
                                 "screenView"
                                 ).toString();

    m_screenViewButtons = m_settings.value(
                                        "screenViewButtons",
                                        "open"
                                        ).toString();

    m_setView = m_settings.value(
                              "setView",
                              "open"
                              ).toString();

    m_ipAddress = m_settings.value(
                              "ipAddress",
                              "192.168.0.100"
                              ).toString();

    m_port = m_settings.value(
                              "port",
                              "60023"
                              ).toUInt();

    m_brightness = m_settings.value(
                              "brightness",
                              "4"
                              ).toUInt();

}

AppSettings& AppSettings::instance(){
    static AppSettings inst;
    return inst;
}

QString AppSettings::screenView() const{
    return m_screenView;
}

void AppSettings::setScreenView(const QString &mode){
    if (mode == m_screenView)
        return;

    m_screenView = mode;

    m_settings.setValue(
        "screenView",
        mode
        );

    emit screenViewChanged();
}

QString AppSettings::screenViewButtons() const{
    return m_screenViewButtons;
}

void AppSettings::setScreenViewButtons(const QString &mode){
    if (mode == m_screenViewButtons)
        return;

    m_screenViewButtons = mode;

    m_settings.setValue(
        "screenViewButtons",
        mode
        );

    emit screenViewButtonsChanged();
}

QString AppSettings::setView() const{
    return m_setView;
}

void AppSettings::setSetView(const QString &state){
    if (state == m_setView)
        return;

    m_setView = state;

    m_settings.setValue(
        "setView",
        state
        );

    emit setViewChanged();
}

QString AppSettings::ipAddress() const{
    return m_ipAddress;
}

void AppSettings::setIpAddress(const QString &address){
    if (address == m_ipAddress)
        return;

    m_ipAddress = address;

    m_settings.setValue(
        "ipAddress",
        address
        );

    emit ipAddressChanged(address);
}

quint16 AppSettings::port() const{
    return m_port;
}

void AppSettings::setPort(const quint16 &portNumber){
    if (portNumber == m_port)
        return;

    m_port = portNumber;

    m_settings.setValue(
        "port",
        portNumber
        );

    emit portChanged(portNumber);
}

quint8 AppSettings::brightness() const{
    return m_brightness;
}

void AppSettings::setBrightness(const quint8 &level){
    if (level == m_brightness)
        return;

    m_brightness = level;

    m_settings.setValue(
        "brightness",
        level
        );

    emit brightnessChanged(level);
}