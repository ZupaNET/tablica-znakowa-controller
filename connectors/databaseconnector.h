#ifndef DATABASECONNECTOR_H
#define DATABASECONNECTOR_H

#include <QObject>
#include <QSqlDatabase>

class DatabaseConnector : public QObject
{
    Q_OBJECT
public:
    static DatabaseConnector& instance();

    QSqlDatabase db();

    bool init(const QString& path = "tablica.db");

private:
    QSqlDatabase m_db;
};

#endif // DATABASECONNECTOR_H
