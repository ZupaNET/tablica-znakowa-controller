// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef SET_H
#define SET_H

#include <QtQml/QtQml>
#include <QString>

struct Set {
    Q_GADGET

    Q_PROPERTY(int setId MEMBER id)
    Q_PROPERTY(QString setName MEMBER name)
    Q_PROPERTY(int order MEMBER order)

public:
    int id;
    QString name;
    int order;
};
Q_DECLARE_METATYPE(Set)

#endif // SET_H
