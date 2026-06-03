#include "databaseimporter.h"
#include "connectors/databaseconnector.h"
#include <QFile>
#include <QUrl>
#include <QDebug>
#include <QSqlDatabase>

DatabaseImporter::DatabaseImporter(QObject *parent)
    : QObject{parent}
{}

bool DatabaseImporter::importDatabase(const QString& sourceUrl){
    qDebug() << "Ścieżka źródłowa: " << sourceUrl;

    QString destinationPath = DatabaseConnector::getDatabasePath();
    qDebug() << "Import do " << destinationPath;

    QSqlDatabase db = DatabaseConnector::instance().db();

    if(db.isOpen()){
        db.close();
    }

    QFile::remove(destinationPath);

    QUrl url(sourceUrl);
    QFile source(url.isLocalFile() ? url.toLocalFile() : url.toString());

    if(!source.open(QIODevice::ReadOnly))
    {
        qDebug() << "Nie udało się otworzyć źródła";
        return false;
    }

    QFile destination(destinationPath);

    if(!destination.open(QIODevice::WriteOnly))
    {
        qDebug() << "Nie udało się otworzyć celu";
        return false;
    }

    destination.write(source.readAll());

    source.close();
    destination.close();

    if(!DatabaseConnector::instance().init(destinationPath)){
        qDebug() << "Błąd: Nie udało się otworzyć nowego pliku bazy danych.";
        return false;
    }

    qDebug() << "Importowanie zakończone powodzeniem.";
    return true;
}
