#ifndef DATABASEIMPORTER_H
#define DATABASEIMPORTER_H

#include <QObject>

class DatabaseImporter : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseImporter(QObject *parent = nullptr);

    Q_INVOKABLE bool importDatabase(const QString& sourceUrl);

signals:
};

#endif // DATABASEIMPORTER_H
