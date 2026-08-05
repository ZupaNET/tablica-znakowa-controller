#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QFontDatabase>
#include <QStyleHints>
#include <QIcon>
#include <QTranslator>
#include <QLocale>
#include <QDir>
#include "core/appinfo.h"

QStringList availableLanguages()
{
    QStringList result;

    QDir dir(":/i18n");

    foreach (const QString &file, dir.entryList({"prezenter_*.qm"}, QDir::Files))
    {
        QString lang =
            file;

        lang.remove("prezenter_");
        lang.remove(".qm");

        result.append(lang);
    }

    return result;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Fix bug with selection on TextField and TextArea. More like a workaround
#ifdef Q_OS_ANDROID
    qputenv("QT_QUICK_CONTROLS_TEXT_SELECTION_BEHAVIOR", "old");
    QGuiApplication::styleHints()->setMousePressAndHoldInterval(300);
#endif

    // Setting style and fonts
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

    // Load translations
    QTranslator appTranslator;
    QString language = QLocale::system().name();
    if(!appTranslator.load(":/i18n/prezenter_" + language + ".qm"))
    {
        language = QLocale::system().name().left(2);
        if(!appTranslator.load(":/i18n/prezenter_" +language +".qm"))
        {
            qDebug() << "Cannot load program language for " << language;
        }
    }
    app.installTranslator(&appTranslator);

    // Load system translations
#ifdef Q_OS_ANDROID
    QTranslator qtBaseTranslator;
    QString lang = QLocale::system().name().left(2);
    if(!qtBaseTranslator.load(":/qt-translations/qtbase_" + lang + ".qm"))
        qDebug() << "Cannot load qtbase translations for " << lang;
    app.installTranslator(&qtBaseTranslator);
#endif

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
