#include "databaseconnector.h"
#include <QDebug>
#include <QStandardPaths>
#include <QDir>
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

QString DatabaseConnector::getDatabasePath(){
    QString dir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir().mkpath(dir);

    return dir+"/hymnal.db";
}

QSqlDatabase DatabaseConnector::db(){
    return m_db;
}

bool DatabaseConnector::init(const QString& path){
    QString realPath = path;

    if(realPath.isEmpty()){
        realPath = getDatabasePath();
    }

    if(QSqlDatabase::contains("hymns"))
        m_db = QSqlDatabase::database("hymns");
    else
        m_db = QSqlDatabase::addDatabase("QSQLITE", "hymns");

    m_db.setDatabaseName(realPath);

    if(!m_db.open()) {
        qDebug() << "[DatabaseManager] Cannot open the database: " << m_db.lastError();
        return false;
    }

    QSqlQuery q(m_db);
    q.exec("PRAGMA foreign_keys = ON");

    return true;
}