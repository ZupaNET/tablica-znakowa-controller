#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include <QDebug>

#include "settings/appsettings.h"

#include <connectors/tablicaconnector.h>
#include "connectors/databaseconnector.h"
#include "managers/databaseimporter.h"
#include "models/screenlistmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //Setting style
    QQuickStyle::setStyle("Material");

    app.setApplicationName("Tablica Znakowa");
    //app.setOrganizationName("Example");
    //app.setOrganizationDomain("example.one.net");
    //app.setWindowIcon(QIcon(":/icons/appicon.png"));

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    //Registering AppSettings singleton - it holds setiings :)
    AppSettings appSettings;
    qmlRegisterSingletonInstance(
        "TablicaZnakowa",
        1, 0,
        "AppSettings",
        &appSettings
    );

    //Registering TablicaConnector singleton - it is used to communicate with Tablisa
    TablicaConnector tablica;
    qmlRegisterSingletonInstance(
        "TablicaZnakowa",
        1, 0,
        "TablicaConnector",
        &tablica
    );

    //Initialising database connection
    if (!DatabaseConnector::instance().init()){
        qFatal("Błąd: Nie udało się otworzyć bazy danych.");
    }else{
        qDebug()<<"Pomyślnie otworzono bazę danych.";
    }

    //Registering DatabaseImporter as a context
    DatabaseImporter databaseImporter;
    engine.rootContext()->setContextProperty(
        "DatabaseImporter", &databaseImporter
    );

    //Registering Screen type - it represensts data that Tablica displays
    qRegisterMetaType<Screen>("Screen");
    qmlRegisterUncreatableType<Screen>(
        "TablicaZnakowa",
        1, 0,
        "screen",
        "DTO only"
    );

    //Registering ScreenListModel - it holds screens list
    qmlRegisterType<ScreenListModel>(
        "TablicaZnakowa",
        1, 0,
        "ScreenListModel"
    );

    engine.loadFromModule("TablicaZnakowa", "Main");

    return QCoreApplication::exec();
}
