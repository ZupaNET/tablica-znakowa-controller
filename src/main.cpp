#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QFontDatabase>
#include <QIcon>
#include "core/appinfo.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //Setting style and fonts
    app.setWindowIcon(QIcon(":/icons/app-icon.png"));
    QQuickStyle::setStyle("Material");
    QFontDatabase::addApplicationFont(":/fonts/materialdesignicons-webfont.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Arimo-Italic-VariableFont_wght.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Arimo-VariableFont_wght.ttf");
    QFontDatabase::addApplicationFont(":/fonts/MiniForma2.ttf");
    QFontDatabase::addApplicationFont(":/fonts/MiniSet2.ttf");
    QFontDatabase::addApplicationFont(":/fonts/FreeSans.ttf");

    app.setApplicationName(AppInfo::instance().name());
    app.setOrganizationName(AppInfo::instance().company());
    app.setOrganizationDomain(AppInfo::instance().companyDomain());
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("Prezenter", "Main");
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "QML loading failed";
        return -1;
    }

    return QCoreApplication::exec();
}
