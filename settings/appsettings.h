#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>
#include <QSettings>

class AppSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString screenView
                    READ screenView
                    WRITE setScreenView
                    NOTIFY screenViewChanged)

    Q_PROPERTY(QString screenViewButtons
                    READ screenViewButtons
                    WRITE setScreenViewButtons
                    NOTIFY screenViewButtonsChanged)

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

public:
    static AppSettings& instance();

    explicit AppSettings(QObject *parent = nullptr);

    QString screenView() const;
    void setScreenView(const QString &mode);

    QString screenViewButtons() const;
    void setScreenViewButtons(const QString &state);

    QString setView() const;
    void setSetView(const QString &state);

    QString ipAddress() const;
    void setIpAddress(const QString &address);

    quint16 port() const;
    void setPort(const quint16 &portNumber);

    quint8 brightness() const;
    void setBrightness(const quint8 &level);

signals:
    void screenViewChanged();
    void screenViewButtonsChanged();
    void setViewChanged();
    void ipAddressChanged(QString);
    void portChanged(quint16);
    void brightnessChanged(quint8);

private:
    QSettings m_settings;

    QString m_screenView;
    QString m_screenViewButtons;
    QString m_setView;
    QString m_ipAddress;
    quint16 m_port;
    quint8 m_brightness;

};

#endif // APPSETTINGS_H
