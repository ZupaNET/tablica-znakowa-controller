#include "appsettings.h"

AppSettings::AppSettings(QObject *parent)
    : QObject(parent)
{
    m_screenView = m_settings.value(
                                    "screenView",
                                    "screenView"
                                    ).toString();

    m_setView = m_settings.value(
                                "setView",
                                "open"
                                ).toString();
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