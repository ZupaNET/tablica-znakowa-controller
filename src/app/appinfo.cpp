// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "appinfo.h"
#include "appinfo_config.h"

AppInfo *AppInfo::create(QQmlEngine *, QJSEngine *engine)
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

QString AppInfo::name() const
{
#ifdef APP_NAME
    return QStringLiteral(APP_NAME);
#else
    return {};
#endif
}

QString AppInfo::company() const
{
#ifdef APP_COMPANY
    return QStringLiteral(APP_COMPANY);
#else
    return {};
#endif
}

QString AppInfo::companyDomain() const
{
#ifdef APP_COMPANY_DOMAIN
    return QStringLiteral(APP_COMPANY_DOMAIN);
#else
    return {};
#endif
}

QString AppInfo::version() const
{
#ifdef APP_VERSION_STRING
    return QStringLiteral(APP_VERSION_STRING);
#else
    return {};
#endif
}

int AppInfo::versionMajor() const
{
#ifdef APP_VERSION_MAJOR
    return APP_VERSION_MAJOR;
#else
    return 0;
#endif
}

int AppInfo::versionMinor() const
{
#ifdef APP_VERSION_MINOR
    return APP_VERSION_MINOR;
#else
    return 0;
#endif
}

int AppInfo::versionPatch() const
{
#ifdef APP_VERSION_PATCH
    return APP_VERSION_PATCH;
#else
    return 0;
#endif
}