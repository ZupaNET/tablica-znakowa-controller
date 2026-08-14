// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef HYMNREPOSITORY_H
#define HYMNREPOSITORY_H

#include <QList>

#include "domain/dto/hymn.h"

class HymnRepository
{
public:
    QList<Hymn> getAll();
    QList<Hymn> getByCategory(int categoryId);
    Hymn create(const QString& name, int categoryId);
    void update(int id, const QString& name, int categoryId);
    void remove(int id);
};

#endif // HYMNREPOSITORY_H
