// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef CATEGORY_H
#define CATEGORY_H

#include <QtQml/QtQml>
#include <QString>

struct Category {
    Q_GADGET

    Q_PROPERTY(int categoryId MEMBER id)
    Q_PROPERTY(QString categoryName MEMBER name)
    Q_PROPERTY(int order MEMBER order)

public:
    int id;
    QString name;
    int order;
};
Q_DECLARE_METATYPE(Category);

#endif // CATEGORY_H
