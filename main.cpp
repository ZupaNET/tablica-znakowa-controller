#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include <connectors/tablicaconnector.h>

int main(int argc, char *argv[])
{
    TablicaConnector tablicaZnakowa;

    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);


    engine.rootContext()->setContextProperty("tablicaZnakowa", &tablicaZnakowa);
    engine.loadFromModule("TablicaZnakowa", "PresenterMode");

    return QCoreApplication::exec();
}
