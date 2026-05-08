#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#pragma once

#include <QObject>
#include <QSettings>

class AppSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString screenView
                    READ screenView
                    WRITE setScreenView
                    NOTIFY screenViewChanged)

    Q_PROPERTY(QString setView
                    READ setView
                    WRITE setSetView
                    NOTIFY setViewChanged)

public:
    explicit AppSettings(QObject *parent = nullptr);

    QString screenView() const;
    void setScreenView(const QString &mode);

    QString setView() const;
    void setSetView(const QString &state);


signals:
    void screenViewChanged();
    void setViewChanged();

private:
    QSettings m_settings;

    QString m_screenView;
    QString m_setView;
};
#endif // APPSETTINGS_H
