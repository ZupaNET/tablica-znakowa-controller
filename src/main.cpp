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

    app.setApplicationName(QString::fromUtf8(QStringLiteral(APP_NAME).toLatin1()));
    app.setOrganizationName(QString::fromUtf8(QStringLiteral(APP_COMPANY).toLatin1()));
    app.setOrganizationDomain(QString::fromUtf8(QStringLiteral(APP_COMPANY_DOMAIN).toLatin1()));

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
