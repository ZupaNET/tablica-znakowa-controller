// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef SCREENAWAKE_H
#define SCREENAWAKE_H

#include <QObject>
#include <QtQml/QtQml>

class ScreenAwake : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT

    explicit ScreenAwake(QObject* parent = nullptr)
        : QObject(parent)
    {
    }

public:

    ScreenAwake(const ScreenAwake&) = delete;
    ScreenAwake(ScreenAwake&&)      = delete;

    ScreenAwake& operator=(const ScreenAwake&) = delete;
    ScreenAwake& operator=(ScreenAwake&&)      = delete;

    static ScreenAwake *create(QQmlEngine *, QJSEngine *);

    static ScreenAwake& instance()
    {
        static ScreenAwake* inst = new ScreenAwake;
        return *inst;
    }

    Q_INVOKABLE void preventSleep();
    Q_INVOKABLE void allowSleep();

private:
    bool m_enabled = false;
    inline static QJSEngine *s_engine = nullptr;

#ifdef Q_OS_WINDOWS
    bool m_windowsActive = false;
#endif

#ifdef Q_OS_MACOS
    unsigned int m_assertionId = 0;
#endif
};

#endif // SCREENAWAKE_H
