#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>
#include <QtQml>
#include <QSettings>

class AppSettings : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT

    Q_PROPERTY(QString screenCustomText
        READ screenCustomText
        WRITE setScreenCustomText
        NOTIFY screenCustomTextChanged)

    Q_PROPERTY(int screenCustomFont
        READ screenCustomFont
        WRITE setScreenCustomFont
        NOTIFY screenCustomFontChanged)

    Q_PROPERTY(QString screenView
        READ screenView
        WRITE setScreenView
        NOTIFY screenViewChanged)

    Q_PROPERTY(QString screenViewButtons
        READ screenViewButtons
        WRITE setScreenViewButtons
        NOTIFY screenViewButtonsChanged)

    Q_PROPERTY(bool showPreview
        READ showPreview
        WRITE setShowPreview
        NOTIFY showPreviewChanged)

    Q_PROPERTY(QString setView
        READ setView
        WRITE setSetView
        NOTIFY setViewChanged)

    Q_PROPERTY(QString ipAddress
        READ ipAddress
        WRITE setIpAddress
        NOTIFY ipAddressChanged)

    Q_PROPERTY(quint16 port
        READ port
        WRITE setPort
        NOTIFY portChanged)

    Q_PROPERTY(quint8 brightness
        READ brightness
        WRITE setBrightness
        NOTIFY brightnessChanged)

    Q_PROPERTY(bool darkMode
        READ darkMode
        WRITE setDarkMode
        NOTIFY darkModeChanged)

    Q_PROPERTY(QString language
        READ language
        WRITE setLanguage
        NOTIFY languageChanged)

explicit AppSettings(QObject* parent = nullptr)
    : QObject(parent)
{
}

public:
    AppSettings(const AppSettings&) = delete;
    AppSettings(AppSettings&&)      = delete;

    AppSettings& operator=(const AppSettings&) = delete;
    AppSettings& operator=(AppSettings&&)      = delete;

    static AppSettings *create(QQmlEngine *, QJSEngine *);

    static AppSettings& instance()
    {
        static AppSettings inst{};
        inst.init();
        return inst;
    }

    void init();

    QString screenCustomText() const;
    void setScreenCustomText(const QString &text);

    int screenCustomFont() const;
    void setScreenCustomFont(const int &font);

    QString screenView() const;
    void setScreenView(const QString &mode);

    QString screenViewButtons() const;
    void setScreenViewButtons(const QString &state);

    bool showPreview() const;
    void setShowPreview(const bool &preview);

    QString setView() const;
    void setSetView(const QString &state);

    QString ipAddress() const;
    void setIpAddress(const QString &address);

    quint16 port() const;
    void setPort(const quint16 &portNumber);

    quint8 brightness() const;
    void setBrightness(const quint8 &level);

    bool darkMode() const;
    void setDarkMode(const bool &dark);

    QString language() const;
    void setLanguage(const QString &name);

signals:
    void screenCustomTextChanged();
    void screenCustomFontChanged();
    void screenViewChanged();
    void screenViewButtonsChanged();
    void showPreviewChanged();
    void setViewChanged();
    void ipAddressChanged(QString);
    void portChanged(quint16);
    void brightnessChanged(quint8);
    void darkModeChanged();
    void languageChanged();

private:
    bool m_initialized = false;
    QSettings m_settings;

    QString m_screenCustomText;
    int m_screenCustomFont = 2;
    QString m_screenView;
    QString m_screenViewButtons;
    bool m_showPreview;
    QString m_setView;
    QString m_ipAddress;
    quint16 m_port;
    quint8 m_brightness;
    bool m_darkMode;
    QString m_language;

    inline static QJSEngine *s_engine = nullptr;
};

#endif // APPSETTINGS_H
