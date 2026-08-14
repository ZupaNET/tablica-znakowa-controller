// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "screenawake.h"

#ifdef Q_OS_WINDOWS
#include <windows.h>
#endif

#ifdef Q_OS_MACOS
#include <IOKit/pwr_mgt/IOPMLib.h>
#endif

#ifdef Q_OS_ANDROID
#include <QJniObject>
#elif defined(Q_OS_LINUX)
#include <QDBusInterface>
#include <QDBusReply
#endif



ScreenAwake *ScreenAwake::create(QQmlEngine *, QJSEngine *engine)
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


void ScreenAwake::preventSleep()
{
    if(m_enabled)
        return;

    m_enabled = true;

#ifdef Q_OS_WINDOWS

    SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED);

    m_windowsActive = true;

#elif defined(Q_OS_MACOS)

    IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleDisplaySleep, kIOPMAssertionLevelOn, CFSTR("Prezenter active presentation"), &m_assertionId);

#elif defined(Q_OS_ANDROID)

    QNativeInterface::QAndroidApplication::runOnAndroidMainThread([] {
        QJniObject activity = QNativeInterface::QAndroidApplication::context();

        if(activity.isValid())
        {
            QJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");

            if(window.isValid())
            {
                const jint FLAG_KEEP_SCREEN_ON = 0x00000080;

                window.callMethod<void>("addFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
            }
        }
    });

#elif defined(Q_OS_LINUX)

    QDBusInterface iface("org.freedesktop.ScreenSaver", "/ScreenSaver", "org.freedesktop.ScreenSaver", QDBusConnection::sessionBus());

    if(iface.isValid())
        iface.call("Inhibit", "Prezenter", "Presentation mode");

#endif

}

void ScreenAwake::allowSleep()
{
    if(!m_enabled)
        return;

    m_enabled = false;

#ifdef Q_OS_WINDOWS

    SetThreadExecutionState(ES_CONTINUOUS);

#elif defined(Q_OS_MACOS)

    if(m_assertionid)
    {
        IOPMAssertionRelease(m_assertionId);

        m_assertionId = 0;
    }

#elif defined(Q_OS_ANDROID)

    QNativeInterface::QAndroidApplication::runOnAndroidMainThread([] {
        QJniObject activity = QNativeInterface::QAndroidApplication::context();


        if(activity.isValid())
        {
            QJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");

            if(window.isValid())
            {
                const jint FLAG_KEEP_SCREEN_ON = 0x00000080;

                window.callMethod<void>("clearFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
            }
        }
    });

#elif defined(Q_OS_LINUX)

// To be implemented

#endif
}