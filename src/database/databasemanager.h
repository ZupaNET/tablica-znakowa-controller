#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QtQml>

class DatabaseManager : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT

explicit DatabaseManager(QObject* parent = nullptr)
    : QObject(parent)
{
}

public:
    DatabaseManager(const DatabaseManager&) = delete;
    DatabaseManager(DatabaseManager&&)      = delete;

    DatabaseManager& operator=(const DatabaseManager&) = delete;
    DatabaseManager& operator=(DatabaseManager&&)      = delete;

    static DatabaseManager *create(QQmlEngine *, QJSEngine *);

    static DatabaseManager& instance()
    {
        static DatabaseManager* inst = new DatabaseManager;
        return *inst;
    }

    Q_INVOKABLE bool importDatabase(const QString& sourceUrl);
    Q_INVOKABLE bool exportDatabase(const QString& destinationUrl);

private:
    inline static QJSEngine *s_engine = nullptr;
};

#endif // DATABASEMANAGER_H
