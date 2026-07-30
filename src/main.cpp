#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //Setting style and fonts
    QQuickStyle::setStyle("Material");
    QFontDatabase::addApplicationFont(":/fonts/materialdesignicons-webfont.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Arimo-Italic-VariableFont_wght.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Arimo-VariableFont_wght.ttf");
    QFontDatabase::addApplicationFont(":/fonts/MiniForma2.ttf");
    QFontDatabase::addApplicationFont(":/fonts/MiniSet2.ttf");
    QFontDatabase::addApplicationFont(":/fonts/FreeSans.ttf");

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
