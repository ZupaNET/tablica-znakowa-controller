// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#include "languagemanager.h"
#include "appsettings.h"

LanguageManager *LanguageManager::create(QQmlEngine *, QJSEngine *engine)
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

void LanguageManager::init()
{
    if(m_initialized)
        return;

    m_initialized = true;

    QString lang = AppSettings::instance().language();

    if(lang.isEmpty())
        lang = QLocale::system().name();

    setLanguage(lang);
}


QVariantList LanguageManager::availableLanguages() const
{
    QVariantList result;

    QDir dir(":/i18n");

    const auto files =
        dir.entryList({"prezenter_*.qm"}, QDir::Files);

    for (const QString &file : files)
    {
        QString locale = file;
        locale.remove("prezenter_");
        locale.remove(".qm");

        QVariantMap item;
        item["lang"] = locale;

        QLocale ql(locale);
        QString name = ql.nativeLanguageName();

        if (!name.isEmpty())
            name[0] = name[0].toUpper();

        item["name"] = name;

        result.append(item);
    }

    return result;
}

QString LanguageManager::language() const
{
    return m_language;
}

QStringList LanguageManager::availableLanguageCodes() const
{
    QStringList result;

    QDir dir(":/i18n");

    for (QString file : dir.entryList({"prezenter_*.qm"}, QDir::Files))
    {
        file.remove("prezenter_");
        file.remove(".qm");

        result << file;
    }

    return result;
}

void LanguageManager::setLanguage(const QString &language)
{
    QString lang = language;

    if (lang == m_language)
        return;

    auto *app = QCoreApplication::instance();

    if (!app)
        return;

    const QStringList available = availableLanguageCodes();

    if (!available.contains(lang))
    {
        QString shortName = lang.left(2);

        if (available.contains(shortName))
            lang = shortName;
        else
            return;
    }

    app->removeTranslator(&m_appTranslator);

#ifdef Q_OS_ANDROID
    app->removeTranslator(&m_qtTranslator);
#endif

    if (!m_appTranslator.load(":/i18n/prezenter_" + lang + ".qm"))
    {
        qWarning() << "Cannot load translation:" << lang;
        return;
    }

    app->installTranslator(&m_appTranslator);

#ifdef Q_OS_ANDROID

    QString qtLanguage = lang.left(2);

    if (m_qtTranslator.load(":/qt-translations/qtbase_" + qtLanguage + ".qm"))
        app->installTranslator(&m_qtTranslator);

#endif

    m_language = lang;

    AppSettings::instance().setLanguage(lang);

    emit languageChanged();
}