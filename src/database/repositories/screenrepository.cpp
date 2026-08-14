// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "screenrepository.h"

#include <QSqlQuery>
#include <QSqlError>

#include "database/databaseconnector.h"

QList<Screen> ScreenRepository::getByHymn(int hymnId)
{
    QList<Screen> list;
    QSqlQuery q( DatabaseConnector::instance().db() );

    q.prepare(R"(
        SELECT Screens.Id AS Id,
               Hymns.Name As HymnName,
               Screens.Text,
               Screens.DisplayOrder,
               Screens.Font
        FROM Screens
        JOIN Hymns ON Screens.HymnId = Hymns.Id
        WHERE HymnId=?
        ORDER BY Screens.DisplayOrder
    )");

    q.addBindValue(hymnId);
    q.exec();

    while (q.next()) {
        list.append({
            q.value(0).toInt(), hymnId,
            q.value(1).toString(),
            q.value(2).toString(),
            q.value(3).toInt(),
            q.value(4).toInt()
        });
    }
    return list;
}

Screen ScreenRepository::create(int hymnId, const QString &text, int font)
{
    QSqlQuery q( DatabaseConnector::instance().db() );

    q.prepare(R"(
        INSERT INTO Screens(HymnId, Text, DisplayOrder, Font)
        VALUES(
            ?, ?,
            (
                SELECT COALESCE(MAX(DisplayOrder)+1, 0)
                FROM Screens
                WHERE HymnId=?
            ),
            ?
        )
    )");

    q.addBindValue(hymnId);
    q.addBindValue(text);
    q.addBindValue(hymnId);
    q.addBindValue(font);

    if (!q.exec()) {
        qCritical() << q.lastError();
        return {};
    }

    int id = q.lastInsertId().toInt();

    q.prepare(R"(
        SELECT
            Screens.Id,
            HymnId,
            Hymns.Name,
            Text,
            DisplayOrder,
            Font
        FROM Screens JOIN Hymns ON Screens.HymnId = Hymns.Id
        WHERE Screens.Id = ?
    )");

    q.addBindValue(id);

    if (!q.exec() || !q.next()) {
        qCritical() << q.lastError();
        return {};
    }

    return {
        q.value(0).toInt(),   // Id
        q.value(1).toInt(),   // HymnId
        q.value(2).toString(),// HymnName
        q.value(3).toString(),// Text
        q.value(4).toInt(),   // Order
        q.value(5).toInt()    // Font
    };
}

void ScreenRepository::update(int id, const QString& text, int font)
{
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        UPDATE Screens
        SET Text=?, Font=?
        WHERE Id=?
    )");
    q.addBindValue(text);
    q.addBindValue(font);
    q.addBindValue(id);
    q.exec();
}

void ScreenRepository::remove(int id)
{
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        DELETE FROM Screens
        WHERE Id=?
    )");
    q.addBindValue(id);
    q.exec();
}

void ScreenRepository::move(int hymnId, int screenId, int from, int to)
{
    QSqlDatabase db = DatabaseConnector::instance().db();

    db.transaction();

    QSqlQuery q(db);

    if (from < to)
    {
        q.prepare(R"(
            UPDATE Screens
            SET DisplayOrder = DisplayOrder - 1
            WHERE HymnId = ?
              AND DisplayOrder > ?
              AND DisplayOrder <= ?
        )");

        q.addBindValue(hymnId);
        q.addBindValue(from);
        q.addBindValue(to);

        q.exec();
    }
    else
    {
        q.prepare(R"(
            UPDATE Screens
            SET DisplayOrder = DisplayOrder + 1
            WHERE HymnId = ?
              AND DisplayOrder >= ?
              AND DisplayOrder < ?
        )");

        q.addBindValue(hymnId);
        q.addBindValue(to);
        q.addBindValue(from);

        q.exec();
    }

    q.prepare(R"(
        UPDATE Screens
        SET DisplayOrder = ?
        WHERE Id = ?
    )");

    q.addBindValue(to);
    q.addBindValue(screenId);

    q.exec();

    db.commit();
}