// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef CATEGORYROLES_H
#define CATEGORYROLES_H

#include <QHash>
#include <QByteArray>


class CategoryRoles
{
public:

    enum Roles
    {
        IdRole = Qt::UserRole + 1,
        NameRole,
        OrderRole
    };


    static QHash<int, QByteArray> roleNames()
    {
        return {
            {IdRole, "id"},
            {NameRole, "name"},
            {OrderRole, "order"}
        };
    }
};

#endif // CATEGORYROLES_H
