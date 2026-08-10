// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Prezenter
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef LANGUAGEMANAGER_H
#define LANGUAGEMANAGER_H

#include <QObject>
#include <QtQml/QJSEngine>
#include <QtQml/QQmlEngine>
#include <QTranslator>

class LanguageManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)
    Q_PROPERTY(QVariantList availableLanguages READ availableLanguages CONSTANT)

explicit LanguageManager(QObject* parent = nullptr)
    : QObject(parent)
{
}
public:
    LanguageManager(const LanguageManager&) = delete;
    LanguageManager(LanguageManager&&)      = delete;

    LanguageManager& operator=(const LanguageManager&) = delete;
    LanguageManager& operator=(LanguageManager&&)      = delete;

    static LanguageManager *create(QQmlEngine *, QJSEngine *);

    static LanguageManager& instance()
    {
        static LanguageManager inst{};
        inst.init();
        return inst;
    }

    void init();

    QString language() const;
    void setLanguage(const QString &language);

    QVariantList availableLanguages() const;

signals:
    void languageChanged();

private:
    bool m_initialized = false;
    QString m_language;

    QStringList availableLanguageCodes() const;

    QTranslator m_appTranslator;

#ifdef Q_OS_ANDROID
    QTranslator m_qtTranslator;
#endif

    inline static QJSEngine *s_engine = nullptr;
};

#endif // LANGUAGEMANAGER_H
