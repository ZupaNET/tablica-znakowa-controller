// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef SCREENREPOSITORY_H
#define SCREENREPOSITORY_H

#include <QList>

#include "domain/dto/screen.h"

class ScreenRepository
{
public:
    QList<Screen> getByHymn(int hymnId);
    Screen create(int hymnId, const QString& text, int font);
    void update(int id, const QString& text, int font);
    void remove(int id);
    void move(int hymnId, int screenId, int from, int to);
};

#endif // SCREENREPOSITORY_H
