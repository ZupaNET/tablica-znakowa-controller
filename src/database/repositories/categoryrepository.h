// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef CATEGORYREPOSITORY_H
#define CATEGORYREPOSITORY_H

#include <QList>

#include "domain/dto/catagory.h"
#include "domain/dto/hymn.h"

class CategoryRepository
{
public:
    QList<Category> getAll();
    Category create(const QString& name);
    void update(int id, const QString& name);
    void remove(int id);
    QList<Hymn> getHymns(int categoryId);
    void move(int categoryId, int from, int to);
};

#endif // CATEGORYREPOSITORY_H
