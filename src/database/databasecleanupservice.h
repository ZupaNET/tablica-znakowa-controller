// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef DATABASECLEANUPSERVICE_H
#define DATABASECLEANUPSERVICE_H

#include <QObject>
#include <QQmlEngine>

class DatabaseCleanupService : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

explicit DatabaseCleanupService(QObject* parent = nullptr)
    : QObject(parent)
{
}

public:
    DatabaseCleanupService(const DatabaseCleanupService&) = delete;
    DatabaseCleanupService(DatabaseCleanupService&&)      = delete;

    DatabaseCleanupService& operator=(const DatabaseCleanupService&) = delete;
    DatabaseCleanupService& operator=(DatabaseCleanupService&&)      = delete;

    static DatabaseCleanupService *create(QQmlEngine *, QJSEngine *);

    static DatabaseCleanupService& instance()
    {
        static DatabaseCleanupService* inst = new DatabaseCleanupService;
        return *inst;
    }

    Q_INVOKABLE void reorderCategoriesByName();
    Q_INVOKABLE void reorderSetsByName();

private:
    inline static QJSEngine *s_engine = nullptr;
};

#endif // DATABASECLEANUPSERVICE_H
