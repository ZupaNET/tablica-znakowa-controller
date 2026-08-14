// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef LINEHEIGHTHELPER_H
#define LINEHEIGHTHELPER_H

#include <QObject>
#include <QtQml/QtQml>
#include <QPointer>
#include <QQuickTextDocument>

class LineHeightHelper : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(qreal lineHeight READ lineHeight WRITE setLineHeight NOTIFY lineHeightChanged)
    Q_PROPERTY(Mode lineHeightMode READ lineHeightMode WRITE setLineHeightMode NOTIFY lineHeightModeChanged)

public:
    enum Mode {
        SingleHeight = 0,
        ProportionalHeight = 1,
        FixedHeight = 2,
        MinimumHeight = 3,
        LineDistanceHeight = 4
    };
    Q_ENUM(Mode)

    explicit LineHeightHelper(QObject *parent = nullptr);

    qreal lineHeight() const;
    void setLineHeight(qreal value);

    Mode lineHeightMode() const;
    void setLineHeightMode(Mode mode);

    Q_INVOKABLE void attach(QQuickTextDocument *quickDocument);
    Q_INVOKABLE void detach();

signals:
    void lineHeightChanged();
    void lineHeightModeChanged();

private slots:
    void documentContentsChange(int position, int charsRemoved, int charsAdded);

private:
    void applyToDocument();
    void applyToRange(int position, int charsRemoved, int charsAdded);
    void applyToBlock(class QTextBlock &block);

    bool isEnabled() const;

    QPointer<QTextDocument> m_document;
    qreal m_lineHeight = 0.0;
    Mode m_lineHeightMode = SingleHeight;
    bool m_applying = false;
};

#endif // LINEHEIGHTHELPER_H
