// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "appsettings.h"

AppSettings *AppSettings::create(QQmlEngine *, QJSEngine *engine)
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

void AppSettings::init()
{
    if (m_initialized)
        return;

    m_screenCustomText  = m_settings.value("screenCustomText", "").toString();
    m_screenCustomFont  = m_settings.value("screenCustomFont", 2).toInt();
    m_screenView        = m_settings.value("screenView", "screenView").toString();
    m_screenViewButtons = m_settings.value("screenViewButtons", "open").toString();
    m_showPreview       = m_settings.value("showPreview", false).toBool();
    m_setView           = m_settings.value("setView", "open").toString();
    m_ipAddress         = m_settings.value("ipAddress", "192.168.0.100").toString();
    m_port              = m_settings.value("port", "60023").toUInt();
    m_brightness        = m_settings.value("brightness", "4").toUInt();
    m_darkMode          = m_settings.value("darkMode", false).toBool();
    m_language          = m_settings.value("language", QLocale::system().name()).toString();

    m_initialized = true;
}

QString AppSettings::screenCustomText() const
{
    return m_screenCustomText;
}

void AppSettings::setScreenCustomText(const QString &text)
{
    if(text == m_screenCustomText)
        return;

    m_screenCustomText = text;
    m_settings.setValue("screenCustomText", text);

    emit screenCustomTextChanged();
}

int AppSettings::screenCustomFont() const
{
    return m_screenCustomFont;
}

void AppSettings::setScreenCustomFont(const int &font)
{
    if(font == m_screenCustomFont)
        return;

    m_screenCustomFont = font;
    m_settings.setValue("screenCustomFont", font);

    emit screenCustomFontChanged();
}

QString AppSettings::screenView() const
{
    return m_screenView;
}

void AppSettings::setScreenView(const QString &mode)
{
    if (mode == m_screenView)
        return;

    m_screenView = mode;
    m_settings.setValue("screenView", mode);

    emit screenViewChanged();
}

QString AppSettings::screenViewButtons() const
{
    return m_screenViewButtons;
}

void AppSettings::setScreenViewButtons(const QString &mode)
{
    if (mode == m_screenViewButtons)
        return;

    m_screenViewButtons = mode;
    m_settings.setValue("screenViewButtons", mode);

    emit screenViewButtonsChanged();
}

bool AppSettings::showPreview() const
{
    return m_showPreview;
}

void AppSettings::setShowPreview(const bool &preview)
{
    if(preview == m_showPreview)
        return;

    m_showPreview = preview;
    m_settings.setValue("showPreview", preview);

    emit showPreviewChanged();
}

QString AppSettings::setView() const
{
    return m_setView;
}

void AppSettings::setSetView(const QString &state)
{
    if (state == m_setView)
        return;

    m_setView = state;
    m_settings.setValue("setView", state);

    emit setViewChanged();
}

QString AppSettings::ipAddress() const
{
    return m_ipAddress;
}

void AppSettings::setIpAddress(const QString &address)
{
    if (address == m_ipAddress)
        return;

    m_ipAddress = address;
    m_settings.setValue("ipAddress", address);

    emit ipAddressChanged(address);
}

quint16 AppSettings::port() const
{
    return m_port;
}

void AppSettings::setPort(const quint16 &portNumber)
{
    if (portNumber == m_port)
        return;

    m_port = portNumber;
    m_settings.setValue("port", portNumber);

    emit portChanged(portNumber);
}

quint8 AppSettings::brightness() const
{
    return m_brightness;
}

void AppSettings::setBrightness(const quint8 &level)
{
    if (level == m_brightness)
        return;

    m_brightness = level;
    m_settings.setValue("brightness", level);

    emit brightnessChanged(level);
}

bool AppSettings::darkMode() const
{
    return m_darkMode;
}

void AppSettings::setDarkMode(const bool &dark)
{
    if(dark == m_darkMode)
        return;

    m_darkMode = dark;
    m_settings.setValue("darkMode", dark);

    emit darkModeChanged();
}

QString AppSettings::language() const
{
    return m_language;
}

void AppSettings::setLanguage(const QString &name)
{
    if(name == m_language)
        return;

    m_language = name;
    m_settings.setValue("language", name);

    emit languageChanged();
}