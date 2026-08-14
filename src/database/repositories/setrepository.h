// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef SETREPOSITORY_H
#define SETREPOSITORY_H

#include <QList>

#include "domain/dto/set.h"
#include "domain/dto/hymn.h"
#include "domain/dto/screen.h"

class SetRepository
{
public:
    QList<Set> getAll();
    Set create(const QString& name);
    void update(int id, const QString& name);
    void remove(int id);
    void move(int setId, int from, int to);
    QList<Hymn> getHymns(int setId);
    QList<Screen> getScreens(int setId, int hymnId);
    Hymn addHymn(int setId, int hymnId);
    void removeHymn(int setId, int hymnId);
    void move(int setId, int hymnId, int from, int to);
    void changeScreenVisibility(int setId, int screenId, bool shown);
    void changeScreenVisibilityByHymn(int setId, int hymnId, bool shown);

};

#endif // SETREPOSITORY_H
