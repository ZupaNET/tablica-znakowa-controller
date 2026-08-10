// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "categoryrepository.h"

#include <QSqlQuery>
#include <QSqlError>

#include "database/databaseconnector.h"
#include "core/utils/naturalsort.h"

QList<Category> CategoryRepository::getAll()
{
    QList<Category> list;
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        SELECT Id,
               Name,
               DisplayOrder
        FROM Categories
        ORDER BY DisplayOrder
    )");
    q.exec();

    list.append({-1, QObject::tr("Bez kategorii", "CategoryRepository"), -1});
    while (q.next())
        list.append({
            q.value(0).toInt(),
            q.value(1).toString(),
            q.value(2).toInt()
        });

    return list;
}

Category CategoryRepository::create(const QString &name)
{
    QSqlQuery q( DatabaseConnector::instance().db() );

    q.prepare(R"(
        INSERT INTO Categories(Name, DisplayOrder)
        VALUES(
            ?,
            (SELECT COALESCE(MAX(DisplayOrder) + 1, 0)
             FROM Categories)
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
        FROM Categories
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

void CategoryRepository::update(int id, const QString& name)
{
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        UPDATE Categories
        SET Name=?
        WHERE Id=?
    )");
    q.addBindValue(name);
    q.addBindValue(id);
    q.exec();
}

void CategoryRepository::remove(int id)
{
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        DELETE FROM Categories
        WHERE Id=?
    )");
    q.addBindValue(id);
    q.exec();
}

QList<Hymn> CategoryRepository::getHymns(int categoryId)
{
    QList<Hymn> list;
    QSqlQuery q( DatabaseConnector::instance().db() );

    if (categoryId >= 0) {
        q.prepare(R"(
            SELECT h.Id, h.Name, h.CategoryId
            FROM Hymns h
            WHERE h.CategoryId = ?
            ORDER BY h.Name
        )");

        q.addBindValue(categoryId);
    } else {
        q.prepare(R"(
            SELECT h.Id, h.Name, h.CategoryId
            FROM Hymns h
            WHERE h.CategoryId IS NULL
            ORDER BY h.Name
        )");
    }
    q.exec();

    while (q.next()) {
        int categoryId = q.isNull(2)
        ? -1
        : q.value(2).toInt();

        list.append({
            q.value(0).toInt(),
            q.value(1).toString(),
            categoryId
        });
    }

    // Natural sort
    NaturalSort::Comparator sorter{QLocale(QLocale::Polish)};
    std::sort(list.begin(), list.end(), [&sorter](const Hymn &a, const Hymn &b){
        return sorter.compare(a.name, b.name) < 0;
    });

    return list;
}

void CategoryRepository::move(int categoryId, int from, int to)
{
    QSqlDatabase db = DatabaseConnector::instance().db();

    db.transaction();

    QSqlQuery q(db);

    if (from < to)
    {
        q.prepare(R"(
            UPDATE Categories
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
            UPDATE Categories
            SET DisplayOrder = DisplayOrder + 1
            WHERE DisplayOrder >= ?
              AND DisplayOrder < ?
        )");

        q.addBindValue(to);
        q.addBindValue(from);

        q.exec();
    }

    q.prepare(R"(
        UPDATE Categories
        SET DisplayOrder = ?
        WHERE Id = ?
    )");

    q.addBindValue(to);
    q.addBindValue(categoryId);

    q.exec();

    db.commit();
}