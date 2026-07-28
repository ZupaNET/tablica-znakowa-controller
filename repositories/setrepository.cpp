#include "setrepository.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QList>
#include <QVector>
#include "connectors/databaseconnector.h"

QList<Set> SetRepository::getAll() {
    QList<Set> list;
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("SELECT Id, Name FROM Sets");
    q.exec();

    while (q.next())
        list.append({q.value(0).toInt(), q.value(1).toString()});

    return list;
}

int SetRepository::create(QString name) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("INSERT INTO Sets (Name) VALUES (?)");
    q.addBindValue(name);
    q.exec();
    return q.lastInsertId().toInt();
}

void SetRepository::update(int id, QString name) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("UPDATE Sets SET Name=? WHERE Id=?");
    q.addBindValue(name);
    q.addBindValue(id);
    q.exec();
}

void SetRepository::remove(int id) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("DELETE FROM Sets WHERE Id=?");
    q.addBindValue(id);
    q.exec();
}

QList<Hymn> SetRepository::getHymns(int setId) {
    QList<Hymn> list;
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare(R"(
            SELECT h.Id, h.Name, h.CategoryId, sh.ShownScreens
            FROM Sets_Hymns sh
            JOIN Hymns h ON h.Id = sh.HymnId
            WHERE sh.SetId=?
            ORDER BY sh.DisplayOrder
        )");

    q.addBindValue(setId);
    q.exec();

    while (q.next()) {
        QVariantList shownScreens;

        if(q.value(3).isNull()){
            QSqlQuery qs(
                DatabaseConnector::instance().db()
                );
            qs.prepare(R"(
                SELECT DisplayOrder
                FROM Screens
                WHERE HymnId=?
                ORDER BY DisplayOrder
            )");
            qs.addBindValue(q.value(0).toInt());
            qs.exec();

            while(qs.next()){
                shownScreens.append(qs.value(0).toInt());
            }

        }else{
            for(const QString &number : q.value(3).toString().split(",")){
                shownScreens.append(number.toInt());
            }
        }
        list.append({q.value(0).toInt(), q.value(1).toString(), q.value(2).toInt(), shownScreens});
    }
    return list;
}

void SetRepository::addHymn(int setId, int hymnId) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
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
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("DELETE FROM Sets_Hymns WHERE SetId=? AND HymnId=?");
    q.addBindValue(setId);
    q.addBindValue(hymnId);
    q.exec();
}

void SetRepository::reorder(int setId, QList<int> ids) {
    auto db = DatabaseConnector::instance().db();
    db.transaction();

    QSqlQuery q(db);
    for (int i = 0; i < ids.size(); ++i) {
        q.prepare("UPDATE Sets_Hymns SET DisplayOrder=? WHERE SetId=? AND HymnId=?");
        q.addBindValue(i);
        q.addBindValue(setId);
        q.addBindValue(ids[i]);
        q.exec();
    }

    db.commit();
}

void SetRepository::changeShownScreens(int setId, int hymnId, QVariantList shownScreens) {
    auto db = DatabaseConnector::instance().db();
    db.transaction();

    QStringList list;
    for (QVariant value : shownScreens) {
        list << QString::number(value.toInt());
    }
    QString a = list.join(',');

    QSqlQuery q(db);
    q.prepare("UPDATE Sets_Hymns SET ShownScreens=? WHERE SetId=? AND HymnId=?");
    q.addBindValue(a);
    q.addBindValue(setId);
    q.addBindValue(hymnId);
    q.exec();

    db.commit();
}