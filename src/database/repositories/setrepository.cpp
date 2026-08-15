// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#include "setrepository.h"

#include <QSqlQuery>
#include <QSqlError>

#include "database/databaseconnector.h"

QList<Set> SetRepository::getAll()
{
    QList<Set> list;
    QSqlQuery q( DatabaseConnector::instance().db() );

    q.prepare(R"(
        SELECT Id, Name, DisplayOrder
        FROM Sets
        ORDER BY DisplayOrder
    )");
    q.exec();

    while (q.next())
        list.append({
            q.value(0).toInt(),
            q.value(1).toString(),
            q.value(2).toInt()
        });

    return list;
}

Set SetRepository::create(const QString &name)
{
    QSqlQuery q( DatabaseConnector::instance().db() );

    q.prepare(R"(
        INSERT INTO Sets(Name, DisplayOrder)
        VALUES(
            ?,
            (SELECT COALESCE(MAX(DisplayOrder) + 1, 0)
             FROM Sets)
        )
    )");
    q.addBindValue(name);

    if (!q.exec()) {
        qCritical() << q.lastError();
        return {};
    }

    int id = q.lastInsertId().toInt();

    q.prepare(R"(
        SELECT Id, Name, DisplayOrder
        FROM Sets
        WHERE Id = ?
    )");

    q.addBindValue(id);

    if (!q.exec() || !q.next()) {
        qCritical() << q.lastError();
        return {};
    }

    return {
        q.value(0).toInt(),
        q.value(1).toString(),
        q.value(2).toInt()
    };
}

void SetRepository::update(int id, const QString& name)
{
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        UPDATE Sets
        SET Name=?
        WHERE Id=?
    )");

    q.addBindValue(name);
    q.addBindValue(id);
    q.exec();
}

void SetRepository::remove(int id)
{
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        DELETE FROM Sets
        WHERE Id=?
    )");
    q.addBindValue(id);
    q.exec();
}

void SetRepository::move(int setId, int from, int to)
{
    QSqlDatabase db = DatabaseConnector::instance().db();

    db.transaction();

    QSqlQuery q(db);

    if (from < to)
    {
        q.prepare(R"(
            UPDATE Sets
            SET DisplayOrder = DisplayOrder - 1
            WHERE DisplayOrder > ?
              AND DisplayOrder <= ?
        )");

        q.addBindValue(from);
        q.addBindValue(to);

        q.exec();
    }
    else
    {
        q.prepare(R"(
            UPDATE Sets
            SET DisplayOrder = DisplayOrder + 1
            WHERE DisplayOrder >= ?
              AND DisplayOrder < ?
        )");

        q.addBindValue(to);
        q.addBindValue(from);

        q.exec();
    }

    q.prepare(R"(
        UPDATE Sets
        SET DisplayOrder = ?
        WHERE Id = ?
    )");

    q.addBindValue(to);
    q.addBindValue(setId);

    q.exec();

    db.commit();
}

void SetRepository::reorder()
{
    QSqlDatabase db = DatabaseConnector::instance().db();

    if(!db.transaction())
        return;

    QSqlQuery q(db);

    q.prepare(R"(
        WITH Ordered AS (
            SELECT
                Id,
                ROW_NUMBER() OVER (
                    ORDER BY Name COLLATE NOCASE, Id
                ) - 1 AS NewDisplayOrder
            FROM Sets
        )
        UPDATE Sets
        SET DisplayOrder = (
            SELECT NewDisplayOrder
            FROM Ordered
            WHERE Ordered.Id = Sets.Id
        )
    )");

    if (!q.exec()) {
        db.rollback();
        qWarning() << "Failed to reorder sets:" << q.lastError().text();
        return;
    }

    if (!db.commit()) {
        qWarning() << "Failed to commit set reorder:" << db.lastError().text();
    }
}

QList<Hymn> SetRepository::getHymns(int setId)
{
    QList<Hymn> list;
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        SELECT h.Id, h.Name, h.CategoryId
        FROM Sets_Hymns sh
        JOIN Hymns h ON h.Id = sh.HymnId
        WHERE sh.SetId=?
        ORDER BY sh.DisplayOrder
    )");

    q.addBindValue(setId);
    q.exec();

    while (q.next()) {
        list.append({
            q.value(0).toInt(),
            q.value(1).toString(),
            q.value(2).toInt()
        });
    }

    return list;
}

QList<Screen> SetRepository::getScreens(int setId, int hymnId)
{
    QList<Screen> list;
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        SELECT
            s.Id,
            h.Name AS HymnName,
            h.Id AS HymnId,
            s.Text,
            s.DisplayOrder,
            s.Font,
            CASE
                WHEN ss.ScreenId IS NOT NULL THEN 1
                ELSE 0
            END AS Shown
        FROM Screens s
        JOIN Hymns h
            ON h.Id = s.HymnId
        JOIN Sets_Hymns sh
            ON sh.HymnId = h.Id
           AND sh.SetId = ?
        LEFT JOIN Sets_Screens ss
            ON ss.SetId = ?
           AND ss.ScreenId = s.Id
        WHERE s.HymnId = ?
        ORDER BY s.DisplayOrder
    )");

    q.addBindValue(setId);
    q.addBindValue(setId);
    q.addBindValue(hymnId);


    if (!q.exec()) {
        qWarning() << q.lastError();
        return list;
    }

    while (q.next()) {

        Screen screen;

        screen.id = q.value("Id").toInt();
        screen.hymnId = q.value("HymnId").toInt();
        screen.hymnName = q.value("HymnName").toString();
        screen.text = q.value("Text").toString();
        screen.order = q.value("DisplayOrder").toInt();
        screen.font = q.value("Font").toInt();
        screen.shown = q.value("Shown").toBool();

        list.append(screen);
    }

    return list;
}

Hymn SetRepository::addHymn(int setId, int hymnId)
{
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        INSERT INTO Sets_Hymns (SetId, HymnId, DisplayOrder)
        VALUES (?, ?,
            (SELECT COALESCE(MAX(DisplayOrder)+1,0) FROM Sets_Hymns WHERE SetId=?))
    )");

    q.addBindValue(setId);
    q.addBindValue(hymnId);
    q.addBindValue(setId);
    q.exec();

    q.prepare(R"(
        SELECT Id, Name, CategoryId
        FROM Hymns
        WHERE Id = ?
    )");

    q.addBindValue(hymnId);

    if (!q.exec() || !q.next()) {
        qCritical() << q.lastError();
        return {};
    }

    return {
        q.value(0).toInt(),
        q.value(1).toString(),
        q.value(2).toInt()
    };
}

void SetRepository::removeHymn(int setId, int hymnId)
{
    QSqlDatabase db = DatabaseConnector::instance().db();

    db.transaction();

    QSqlQuery q(db);

    q.prepare(R"(
        DELETE FROM Sets_Screens
        WHERE SetId = ?
          AND ScreenId IN (
              SELECT Id
              FROM Screens
              WHERE HymnId = ?
          )
    )");

    q.addBindValue(setId);
    q.addBindValue(hymnId);

    if (!q.exec()) {
        qWarning() << q.lastError();
        db.rollback();
        return;
    }

    q.prepare(R"(
        DELETE FROM Sets_Hymns
        WHERE SetId = ?
          AND HymnId = ?
    )");

    q.addBindValue(setId);
    q.addBindValue(hymnId);

    if (!q.exec()) {
        qWarning() << q.lastError();
        db.rollback();
        return;
    }

    db.commit();
}

void SetRepository::move(int setId, int hymnId, int from, int to)
{
    QSqlDatabase db = DatabaseConnector::instance().db();

    db.transaction();

    QSqlQuery q(db);

    if (from < to)
    {
        q.prepare(R"(
            UPDATE Sets_Hymns
            SET DisplayOrder = DisplayOrder - 1
            WHERE SetId = ?
              AND DisplayOrder > ?
              AND DisplayOrder <= ?
        )");

        q.addBindValue(setId);
        q.addBindValue(from);
        q.addBindValue(to);

        q.exec();
    }
    else
    {
        q.prepare(R"(
            UPDATE Sets_Hymns
            SET DisplayOrder = DisplayOrder + 1
            WHERE SetId = ?
              AND DisplayOrder >= ?
              AND DisplayOrder < ?
        )");

        q.addBindValue(setId);
        q.addBindValue(to);
        q.addBindValue(from);

        q.exec();
    }

    q.prepare(R"(
        UPDATE Sets_Hymns
        SET DisplayOrder = ?
        WHERE HymnId = ?
    )");

    q.addBindValue(to);
    q.addBindValue(hymnId);

    q.exec();

    db.commit();
}

void SetRepository::changeScreenVisibility(int setId, int screenId, bool shown)
{
    QSqlDatabase db = DatabaseConnector::instance().db();

    {
        QSqlQuery check(db);

        check.prepare(R"(
            SELECT 1
            FROM Screens s
            JOIN Sets_Hymns sh
                ON sh.HymnId = s.HymnId
            WHERE s.Id = ?
              AND sh.SetId = ?
            LIMIT 1
        )");

        check.addBindValue(screenId);
        check.addBindValue(setId);

        if (!check.exec() || !check.next())
        {
            qWarning() << "Screen is not in specified set!";
            return;
        }
    }


    if (!shown)
    {
        QSqlQuery q(db);

        q.prepare(R"(
            DELETE FROM Sets_Screens
            WHERE SetId = ?
              AND ScreenId = ?
        )");

        q.addBindValue(setId);
        q.addBindValue(screenId);

        q.exec();
    }
    else
    {
        QSqlQuery q(db);

        q.prepare(R"(
            INSERT INTO Sets_Screens(SetId, ScreenId)
            SELECT ?, ?
            WHERE NOT EXISTS (
                SELECT 1
                FROM Sets_Screens
                WHERE SetId = ?
                  AND ScreenId = ?
            )
        )");

        q.addBindValue(setId);
        q.addBindValue(screenId);
        q.addBindValue(setId);
        q.addBindValue(screenId);

        q.exec();
    }
}

void SetRepository::changeScreenVisibilityByHymn(int setId, int hymnId, bool shown)
{
    QSqlDatabase db = DatabaseConnector::instance().db();
    {
        QSqlQuery check(db);

        check.prepare(R"(
            SELECT 1
            FROM Sets_Hymns
            WHERE SetId = ?
              AND HymnId = ?
            LIMIT 1
        )");

        check.addBindValue(setId);
        check.addBindValue(hymnId);

        if (!check.exec() || !check.next())
        {
            qWarning() << "Hymn is not in the set";
            return;
        }
    }


    if (!shown)
    {
        QSqlQuery q(db);

        q.prepare(R"(
            DELETE FROM Sets_Screens
            WHERE SetId = ?
              AND ScreenId IN (
                  SELECT Id
                  FROM Screens
                  WHERE HymnId = ?
              )
        )");

        q.addBindValue(setId);
        q.addBindValue(hymnId);

        q.exec();
    }
    else
    {
        QSqlQuery q(db);

        q.prepare(R"(
            INSERT INTO Sets_Screens(SetId, ScreenId)
            SELECT ?, s.Id
            FROM Screens s
            WHERE s.HymnId = ?
              AND NOT EXISTS (
                  SELECT 1
                  FROM Sets_Screens ss
                  WHERE ss.SetId = ?
                    AND ss.ScreenId = s.Id
              )
        )");

        q.addBindValue(setId);
        q.addBindValue(hymnId);
        q.addBindValue(setId);

        q.exec();
    }
}