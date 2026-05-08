#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include <QDebug>

#include <connectors/tablicaconnector.h>
#include "settings/appsettings.h"

#include "models/screenlistmodel.h"
#include "connectors/databaseconnector.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
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

    AppSettings appSettings;
    qmlRegisterSingletonInstance(
        "TablicaZnakowa",
        1, 0,
        "AppSettings",
        &appSettings
    );

    qRegisterMetaType<Screen>("Screen");
    qmlRegisterUncreatableType<Screen>(
        "TablicaZnakowa",
        1, 0,
        "screen",
        "DTO only"
    );

    TablicaConnector tablica;
    qmlRegisterSingletonInstance(
        "TablicaZnakowa",
        1, 0,
        "TablicaConnector",
        &tablica
        );

    if (!DatabaseConnector::instance().init()){
        qFatal("Nie udało się otworzyć bazy danych.");
    }else{
        qDebug()<<"Działa";
    }

    qmlRegisterType<ScreenListModel>(
        "TablicaZnakowa",
        1, 0,
        "ScreenListModel"
    );

    engine.loadFromModule("TablicaZnakowa", "Main");

    return QCoreApplication::exec();
}
