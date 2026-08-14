// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef PRESENTATIONSERVICE_H
#define PRESENTATIONSERVICE_H

#include <QList>
#include "domain/dto/screen.h"
#include "database/repositories/setrepository.h"

class PresentationService
{

public:
    QList<Screen> build(int setId);

private:
    SetRepository setRepo;
};

#endif // PRESENTATIONSERVICE_H
