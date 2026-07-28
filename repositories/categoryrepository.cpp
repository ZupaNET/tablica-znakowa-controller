#include "categoryrepository.h"
#include <QSqlQuery>
#include <QSqlError>
#include "connectors/databaseconnector.h"


CategoryRepository::CategoryRepository() {}

QList<Category> CategoryRepository::getAll() {
    QList<Category> list;
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("SELECT Id, Name FROM Categories");
    q.exec();
    while (q.next())
        list.append({q.value(0).toInt(), q.value(1).toString()});

    return list;
}

int CategoryRepository::create(QString name) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("INSERT INTO Categories (Name) VALUES (?)");
    q.addBindValue(name);
    q.exec();
    return q.lastInsertId().toInt();
}

void CategoryRepository::update(int id, QString name) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("UPDATE Categories SET Name=? WHERE Id=?");
    q.addBindValue(name);
    q.addBindValue(id);
    q.exec();
}

void CategoryRepository::remove(int id) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("DELETE FROM Categories WHERE Id=?");
    q.addBindValue(id);
    q.exec();
}

QList<Hymn> CategoryRepository::getHymns(int categoryId) {
    QList<Hymn> list;
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare(R"(
            SELECT h.Id, h.Name, h.CategoryId
            FROM Hymns h
            WHERE h.CategoryId=?
            ORDER BY h.Name
        )");

    q.addBindValue(categoryId);
    q.exec();

    while (q.next()) {
        list.append({q.value(0).toInt(), q.value(1).toString(), q.value(2).toInt()});
    }
    return list;
}