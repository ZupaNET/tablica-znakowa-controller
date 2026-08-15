// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef HYMN_H
#define HYMN_H

#include <QtQml/QtQml>
#include <QString>

struct Hymn {
    Q_GADGET

    Q_PROPERTY(int hymnId MEMBER id)
    Q_PROPERTY(QString hymnName MEMBER name)
    Q_PROPERTY(int categoryId MEMBER categoryId)

public:
    int id;
    QString name;
    int categoryId;
};
Q_DECLARE_METATYPE(Hymn)

#endif // HYMN_H
