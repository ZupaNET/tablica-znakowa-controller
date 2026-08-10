// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "hymnrepository.h"

#include <QSqlQuery>
#include <QSqlError>

#include "database/databaseconnector.h"
#include "core/utils/naturalsort.h"

QList<Hymn> HymnRepository::getAll()
{
    QList<Hymn> list;
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        SELECT Id,
               Name,
               CategoryId
        FROM hymns
        ORDER BY Name
    )");
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

QList<Hymn> HymnRepository::getByCategory(int categoryId)
{
    QList<Hymn> list;
    QSqlQuery q( DatabaseConnector::instance().db() );

    if (categoryId == -1) {
        q.prepare(R"(
        SELECT Id, Name, CategoryId
        FROM Hymns
        WHERE CategoryId IS NULL
        ORDER BY Name
    )");
    } else {
        q.prepare(R"(
        SELECT Id, Name, CategoryId
        FROM Hymns
        WHERE CategoryId = ?
        ORDER BY Name
    )");
        q.addBindValue(categoryId);
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

Hymn HymnRepository::create(const QString &name, int categoryId)
{
    QSqlQuery q( DatabaseConnector::instance().db() );

    q.prepare(R"(
        INSERT INTO Hymns(Name, CategoryId)
        VALUES(?, ?)
    )");

    q.addBindValue(name);

    if (categoryId < 0)
        q.addBindValue(QVariant(QMetaType::fromType<int>()));
    else
        q.addBindValue(categoryId);

    if (!q.exec()) {
        qCritical() << q.lastError();
        return {};
    }

    int id = q.lastInsertId().toInt();

    q.prepare(R"(
        SELECT Id, Name, CategoryId
        FROM Hymns
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
        categoryId
    };
}

void HymnRepository::update(int id, const QString& name, int categoryId)
{
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        UPDATE Hymns
        SET Name=?, CategoryId=?
        WHERE Id=?
    )");
    q.addBindValue(name);
    q.addBindValue(categoryId < 0 ? QVariant(QMetaType::fromType<int>()) : categoryId);
    q.addBindValue(id);
    q.exec();
}

void HymnRepository::remove(int id) {
    QSqlQuery q( DatabaseConnector::instance().db() );
    q.prepare(R"(
        DELETE FROM Hymns
        WHERE Id=?
    )");
    q.addBindValue(id);
    q.exec();
}
