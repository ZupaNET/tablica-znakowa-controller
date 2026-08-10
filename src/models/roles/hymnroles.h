// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef HYMNROLES_H
#define HYMNROLES_H

#include <QHash>
#include <QByteArray>


class HymnRoles
{
public:

    enum Roles
    {
        IdRole = Qt::UserRole + 1,
        NameRole,
        CategoryRole
    };


    static QHash<int, QByteArray> roleNames()
    {
        return {
            {IdRole, "id"},
            {NameRole, "name"},
            {CategoryRole, "categoryId"}
        };
    }
};

#endif // HYMNROLES_H
