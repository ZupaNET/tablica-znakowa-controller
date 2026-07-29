#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //Setting style
    QQuickStyle::setStyle("Material");

    app.setApplicationName(APP_NAME);
    app.setOrganizationName(APP_COMPANY);
    app.setOrganizationDomain(APP_COMPANY_DOMAIN);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("Prezenter", "Main");

    return QCoreApplication::exec();
}
