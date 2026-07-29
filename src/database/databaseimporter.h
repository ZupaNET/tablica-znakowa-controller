#ifndef DATABASEIMPORTER_H
#define DATABASEIMPORTER_H

#include <QObject>
#include <QtQml>

class DatabaseImporter : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT

explicit DatabaseImporter(QObject* parent = nullptr)
    : QObject(parent)
{
}

public:
    DatabaseImporter(const DatabaseImporter&) = delete;
    DatabaseImporter(DatabaseImporter&&)      = delete;

    DatabaseImporter& operator=(const DatabaseImporter&) = delete;
    DatabaseImporter& operator=(DatabaseImporter&&)      = delete;

    static DatabaseImporter *create(QQmlEngine *, QJSEngine *);

    static DatabaseImporter& instance()
    {
        static DatabaseImporter* inst = new DatabaseImporter;
        return *inst;
    }

    Q_INVOKABLE bool importDatabase(const QString& sourceUrl);

private:
    inline static QJSEngine *s_engine = nullptr;
};

#endif // DATABASEIMPORTER_H
