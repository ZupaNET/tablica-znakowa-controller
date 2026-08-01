#include "databaseconnector.h"
#include <QDebug>
#include <QStandardPaths>
#include <QDir>
#include <QSqlError>
#include <QSqlQuery>
#include <QFileInfo>

DatabaseConnector *DatabaseConnector::create(QQmlEngine *, QJSEngine *engine)
{
    // The instance has to exist before it is used. We cannot replace it.
    Q_ASSERT(&instance());

    // The engine has to have the same thread affinity as the singleton.
    Q_ASSERT(engine->thread() == instance().thread());

    // There can only be one engine accessing the singleton.
    if (s_engine)
        Q_ASSERT(engine == s_engine);
    else
        s_engine = engine;

    // Explicitly specify C++ ownership so that the engine doesn't delete
    // the instance.
    QJSEngine::setObjectOwnership(&instance(),
                                  QJSEngine::CppOwnership);
    return &instance();
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

    if (!QFile::exists(realPath)) {

        QFile defaultDb(":/database/default.db");

        if (!defaultDb.exists()) {
            qDebug() << "[DatabaseManager] Brak zasobu default.db";
            return false;
        }

        QDir dir = QFileInfo(realPath).absoluteDir();

        if (!dir.exists() && !dir.mkpath(".")) {
            qDebug() << "[DatabaseManager] Nie można utworzyć katalogu:"
                     << dir.absolutePath();
            return false;
        }

        if (!defaultDb.copy(realPath)) {
            qDebug() << "[DatabaseManager] Nie można skopiować default.db do:"
                     << realPath;
            return false;
        }

        QFile::setPermissions(
            realPath,
            QFileDevice::ReadOwner |
                QFileDevice::WriteOwner |
                QFileDevice::ReadUser |
                QFileDevice::WriteUser
        );

        qDebug() << "[DatabaseManager] Utworzono bazę z default.db";
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