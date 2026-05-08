#include "screenrepository.h"
#include <QSqlQuery>
#include <QSqlError>
#include "connectors/databaseconnector.h"

QList<Screen> ScreenRepository::getByHymn(int hymnId) {
    QList<Screen> list;
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
;
    q.prepare(R"(SELECT Screens.Id AS Id, Hymns.Name As HymnName, Screens.Text, Screens.DisplayOrder, Screens.Font FROM Screens JOIN Hymns ON Screens.HymnId = Hymns.Id WHERE HymnId=? ORDER BY Screens.DisplayOrder)");
    q.addBindValue(hymnId);
    q.exec();

    while (q.next()) {
        list.append({q.value(0).toInt(), hymnId,
                     q.value(1).toString(),
                     q.value(2).toString(),
                     q.value(3).toInt(),
                     q.value(4).toInt()});
    }
    return list;
}

int ScreenRepository::create(int hymnId, QString text, int font) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare(R"(
            INSERT INTO Screens (HymnId, Text, DisplayOrder, Font)
            VALUES (?, ?,
                (SELECT COALESCE(MAX(DisplayOrder)+1,0) FROM Screens WHERE HymnId=?),
                ?)
        )");

    q.addBindValue(hymnId);
    q.addBindValue(text);
    q.addBindValue(hymnId);
    q.addBindValue(font);
    q.exec();

    return q.lastInsertId().toInt();
}

void ScreenRepository::update(int id, QString text, int font) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("UPDATE Screens SET Text=?, Font=? WHERE Id=?");
    q.addBindValue(text);
    q.addBindValue(font);
    q.addBindValue(id);
    q.exec();
}

void ScreenRepository::remove(int id) {
    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    q.prepare("DELETE FROM Screens WHERE Id=?");
    q.addBindValue(id);
    q.exec();
}

void ScreenRepository::reorder(int hymnId, QList<int> ids) {
    auto db = DatabaseConnector::instance().db();
    db.transaction();

    QSqlQuery q(
        DatabaseConnector::instance().db()
    );
    for (int i = 0; i < ids.size(); ++i) {
        q.prepare("UPDATE Screens SET DisplayOrder=? WHERE Id=? AND HymnId=?");
        q.addBindValue(i);
        q.addBindValue(ids[i]);
        q.addBindValue(hymnId);
        q.exec();
    }

    db.commit();
}