// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef SCREENROLES_H
#define SCREENROLES_H

#include <QHash>
#include <QByteArray>


class ScreenRoles
{

public:

    enum Roles
    {
        IdRole = Qt::UserRole + 1,
        ScreenRole,
        HymnIdRole,
        HymnNameRole,
        TextRole,
        OrderRole,
        FontRole,
        ShownRole,
        ExcerptRole
    };


    static QHash<int,QByteArray> roleNames()
    {
        return {
            {IdRole,"id"},
            {ScreenRole,"screen"},
            {HymnIdRole,"hymnId"},
            {HymnNameRole,"hymnName"},
            {TextRole,"text"},
            {OrderRole,"order"},
            {FontRole,"font"},
            {ShownRole, "shown"},
            {ExcerptRole,"excerpt"}
        };
    }
};

#endif // SCREENROLES_H
