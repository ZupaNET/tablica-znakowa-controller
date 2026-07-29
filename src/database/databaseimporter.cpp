#include "databaseimporter.h"
#include "databaseconnector.h"
#include <QFile>
#include <QUrl>
#include <QDebug>
#include <QSqlDatabase>

DatabaseImporter *DatabaseImporter::create(QQmlEngine *, QJSEngine *engine)
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

bool DatabaseImporter::importDatabase(const QString& sourceUrl)
{
    qDebug() << "Ścieżka źródłowa:" << sourceUrl;

    const QString destinationPath = DatabaseConnector::getDatabasePath();
    qDebug() << "Import do:" << destinationPath;


    QUrl url(sourceUrl);
    QString sourcePath;
    if (url.isLocalFile()) {
        sourcePath = url.toLocalFile();
    } else {
        sourcePath = sourceUrl;
    }

    qDebug() << "Rzeczywista ścieżka źródłowa:" << sourcePath;


    QSqlDatabase db = DatabaseConnector::instance().db();
    if (db.isOpen()) {
        db.close();
    }

    if (!QFile::remove(destinationPath)) {
        if (QFile::exists(destinationPath)) {
            qWarning() << "Nie można usunąć istniejącej bazy";
            return false;
        }
    }

    QFile source(sourcePath);
    if (!source.open(QIODevice::ReadOnly)) {
        qWarning() << "Nie udało się otworzyć źródła:"
                   << source.errorString();
        return false;
    }

    QFile destination(destinationPath);
    if (!destination.open(QIODevice::WriteOnly)) {
        qWarning() << "Nie udało się otworzyć celu:"
                   << destination.errorString();
        return false;
    }

    if (destination.write(source.readAll()) == -1) {
        qWarning() << "Błąd zapisu:"
                   << destination.errorString();
        return false;
    }

    source.close();
    destination.close();

    if (!DatabaseConnector::instance().init(destinationPath)) {
        qWarning() << "Nie udało się otworzyć nowej bazy danych.";
        return false;
    }

    qDebug() << "Importowanie zakończone powodzeniem.";
    return true;
}
