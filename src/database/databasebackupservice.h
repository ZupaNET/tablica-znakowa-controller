// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef DATABASEBACKUPSERVICE_H
#define DATABASEBACKUPSERVICE_H

#include <QObject>
#include <QtQml/QtQml>

class DatabaseBackupService : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT

explicit DatabaseBackupService(QObject* parent = nullptr)
    : QObject(parent)
{
}

public:
    DatabaseBackupService(const DatabaseBackupService&) = delete;
    DatabaseBackupService(DatabaseBackupService&&)      = delete;

    DatabaseBackupService& operator=(const DatabaseBackupService&) = delete;
    DatabaseBackupService& operator=(DatabaseBackupService&&)      = delete;

    static DatabaseBackupService *create(QQmlEngine *, QJSEngine *);

    static DatabaseBackupService& instance()
    {
        static DatabaseBackupService* inst = new DatabaseBackupService;
        return *inst;
    }

    Q_INVOKABLE bool importDatabase(const QString& sourceUrl);
    Q_INVOKABLE bool exportDatabase(const QString& destinationUrl);
    Q_INVOKABLE bool resetDatabase();

private:
    inline static QJSEngine *s_engine = nullptr;
};

#endif // DATABASEBACKUPSERVICE_H
