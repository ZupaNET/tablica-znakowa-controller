#include "databaseconnector.h"
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>

/* Tworzymy tzw. singleton - czyli w całym programie dostępna
 * będzie tylko jedna jedyna instancja klasy DatabaseConnector.
 * Nie potrzebujemy ich więcej.
 */
DatabaseConnector& DatabaseConnector::instance() {
    static DatabaseConnector inst;
    return inst;
}

QSqlDatabase DatabaseConnector::db()
{
    return m_db;
}

bool DatabaseConnector::init(const QString& path)
{
    if(QSqlDatabase::contains("hymns"))
        m_db = QSqlDatabase::database("hymns");
    else
        m_db = QSqlDatabase::addDatabase("QSQLITE", "hymns");

    m_db.setDatabaseName(path);

    if(!m_db.open()) {
        qDebug() << "[DatabaseManager] Cannot open the database: " << m_db.lastError();
        return false;
    }

    QSqlQuery q(m_db);
    q.exec("PRAGMA foreign_keys = ON");

    return true;
}