// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef APPINFO_H
#define APPINFO_H

#include <QObject>
#include <QString>
#include <QtQml/QtQml>

class AppInfo : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT

    Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString company READ company CONSTANT)
    Q_PROPERTY(QString companyDomain READ companyDomain CONSTANT)
    Q_PROPERTY(QString version READ version CONSTANT)

    Q_PROPERTY(int versionMajor READ versionMajor CONSTANT)
    Q_PROPERTY(int versionMinor READ versionMinor CONSTANT)
    Q_PROPERTY(int versionPatch READ versionPatch CONSTANT)

explicit AppInfo(QObject* parent = nullptr)
    : QObject(parent)
{
}

public:
    AppInfo(const AppInfo&) = delete;
    AppInfo(AppInfo&&)      = delete;

    AppInfo& operator=(const AppInfo&) = delete;
    AppInfo& operator=(AppInfo&&)      = delete;

    static AppInfo *create(QQmlEngine *, QJSEngine *);

    static AppInfo& instance()
    {
        static AppInfo inst{};
        return inst;
    }

    QString name() const;
    QString company() const;
    QString companyDomain() const;
    QString version() const;

    int versionMajor() const;
    int versionMinor() const;
    int versionPatch() const;

private:
    inline static QJSEngine *s_engine = nullptr;
};

#endif // APPINFO_H
