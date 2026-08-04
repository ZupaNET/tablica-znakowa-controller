#include "categoryrepository.h"
#include <QSqlQuery>
#include <QSqlError>
#include "database/databaseconnector.h"


CategoryRepository::CategoryRepository() {}

QList<Category> CategoryRepository::getAll() {
    QList<Category> list;
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("SELECT Id, Name FROM Categories");
    q.exec();
    list.append({-1, "Bez kategorii"});
    while (q.next())
        list.append({q.value(0).toInt(), q.value(1).toString()});

    return list;
}

Category CategoryRepository::create(const QString &name)
{
    QSqlQuery q(DatabaseConnector::instance().db());

    q.prepare("INSERT INTO Categories(Name) VALUES(?)");
    q.addBindValue(name);

    if (!q.exec()) {
        qCritical() << q.lastError();
        return {};
    }

    int id = q.lastInsertId().toInt();

    q.prepare(R"(
        SELECT Id, Name
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
        q.value(1).toString()
    };
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
    return list;
}