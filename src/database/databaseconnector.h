// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef DATABASECONNECTOR_H
#define DATABASECONNECTOR_H

#include <QObject>
#include <QtQml/QtQml>
#include <QSqlDatabase>

class DatabaseConnector : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT

explicit DatabaseConnector(QObject* parent = nullptr)
    : QObject(parent)
{
}

public:
    DatabaseConnector(const DatabaseConnector&) = delete;
    DatabaseConnector(DatabaseConnector&&)      = delete;

    DatabaseConnector& operator=(const DatabaseConnector&) = delete;
    DatabaseConnector& operator=(DatabaseConnector&&)      = delete;

    static DatabaseConnector *create(QQmlEngine *, QJSEngine *);

    static DatabaseConnector& instance()
    {
        static DatabaseConnector* inst = new DatabaseConnector;
        if (!inst->m_initialized)
        {
            inst->init();
            inst->m_initialized = true;
        }

        return *inst;
    }

    static QString getDatabasePath();

    QSqlDatabase db();

    bool init(const QString& path = QString());

private:
    bool m_initialized = false;
    QSqlDatabase m_db;

    inline static QJSEngine *s_engine = nullptr;
};

#endif // DATABASECONNECTOR_H
