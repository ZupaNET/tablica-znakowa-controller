#include "hymnrepository.h"
#include <QSqlQuery>
#include <QSqlError>
#include "connectors/databaseconnector.h"

QList<Hymn> HymnRepository::getAll() {
    QList<Hymn> list;
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("SELECT Id, Name, CategoryId FROM hymns");
    q.exec();
    while (q.next()) {
        list.append({q.value(0).toInt(), q.value(1).toString(), q.value(2).toInt()});
    }
    return list;
}

QList<Hymn> HymnRepository::getByCategory(int categoryId) {
    QList<Hymn> list;
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("SELECT Id, Name, CategoryId FROM Hymns WHERE CategoryId IS ?");
    q.addBindValue(categoryId == -1 ? QVariant(QMetaType::fromType<int>()) : categoryId);
    q.exec();

    while (q.next()) {
        list.append({q.value(0).toInt(), q.value(1).toString(), q.value(2).toInt()});
    }
    return list;
}

int HymnRepository::create(const QString& name, int categoryId) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("INSERT INTO Hymns (Name, CategoryId) VALUES (?, ?)");
    q.addBindValue(name);
    if (categoryId < 0) q.addBindValue(QVariant(QMetaType::fromType<int>()));
    else q.addBindValue(categoryId);

    if (!q.exec()) qCritical() << q.lastError();
    return q.lastInsertId().toInt();
}

void HymnRepository::update(int id, const QString& name, int categoryId) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("UPDATE Hymns SET Name=?, CategoryId=? WHERE Id=?");
    q.addBindValue(name);
    q.addBindValue(categoryId < 0 ? QVariant(QMetaType::fromType<int>()) : categoryId);
    q.addBindValue(id);
    q.exec();
}

void HymnRepository::remove(int id) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("DELETE FROM Hymns WHERE Id=?");
    q.addBindValue(id);
    q.exec();
}
