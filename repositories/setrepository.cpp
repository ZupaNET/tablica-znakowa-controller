#include "setrepository.h"
#include <QSqlQuery>
#include <QSqlError>
#include "connectors/databaseconnector.h"

QList<Set> SetRepository::getAll() {
    QList<Set> list;
    QSqlQuery q("SELECT Id, Name FROM Sets");

    while (q.next())
        list.append({q.value(0).toInt(), q.value(1).toString()});

    return list;
}

int SetRepository::create(QString name) {
    QSqlQuery q;
    q.prepare("INSERT INTO Sets (Name) VALUES (?)");
    q.addBindValue(name);
    q.exec();
    return q.lastInsertId().toInt();
}

void SetRepository::update(int id, QString name) {
    QSqlQuery q;
    q.prepare("UPDATE Sets SET Name=? WHERE Id=?");
    q.addBindValue(name);
    q.addBindValue(id);
    q.exec();
}

void SetRepository::remove(int id) {
    QSqlQuery q;
    q.prepare("DELETE FROM Sets WHERE Id=?");
    q.addBindValue(id);
    q.exec();
}

QList<Hymn> SetRepository::getHymns(int setId) {
    QList<Hymn> list;
    QSqlQuery q;
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
        list.append({q.value(0).toInt(), q.value(1).toString(), q.value(2).toInt()});
    }
    return list;
}

void SetRepository::addHymn(int setId, int hymnId) {
    QSqlQuery q;
    q.prepare(R"(
            INSERT INTO Sets_Hymns (SetId, HymnId, DisplayOrder)
            VALUES (?, ?,
                (SELECT COALESCE(MAX(DisplayOrder)+1,0) FROM Sets_Hymns WHERE SetId=?))
        )");

    q.addBindValue(setId);
    q.addBindValue(hymnId);
    q.addBindValue(setId);
    q.exec();
}

void SetRepository::removeHymn(int setId, int hymnId) {
    QSqlQuery q;
    q.prepare("DELETE FROM Sets_Hymns WHERE SetId=? AND HymnId=?");
    q.addBindValue(setId);
    q.addBindValue(hymnId);
    q.exec();
}

void SetRepository::reorder(int setId, QList<int> ids) {
    auto db = DatabaseConnector::instance().db();
    db.transaction();

    QSqlQuery q;
    for (int i = 0; i < ids.size(); ++i) {
        q.prepare("UPDATE Sets_Hymns SET DisplayOrder=? WHERE SetId=? AND HymnId=?");
        q.addBindValue(i);
        q.addBindValue(setId);
        q.addBindValue(ids[i]);
        q.exec();
    }

    db.commit();
}