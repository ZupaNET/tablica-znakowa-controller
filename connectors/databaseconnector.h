#ifndef DATABASECONNECTOR_H
#define DATABASECONNECTOR_H

#include <QObject>
#include <QSqlDatabase>

class DatabaseConnector : public QObject
{
    Q_OBJECT
public:
    static DatabaseConnector& instance();

    static QString getDatabasePath();

    QSqlDatabase db();

    bool init(const QString& path = QString());

private:
    QSqlDatabase m_db;
};

#endif // DATABASECONNECTOR_H
