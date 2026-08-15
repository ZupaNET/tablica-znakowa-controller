// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#include "presentationservice.h"

QList<Screen> PresentationService::build(int setId)
{
    QList<Screen> result;

    auto emptyScreen = Screen::emptyScreen();

    result.append(emptyScreen);

    auto hymns = setRepo.getHymns(setId);

    foreach (const auto& hymn, hymns)
    {
        auto screens = setRepo.getScreens(setId, hymn.id);

        foreach (const auto& screen, screens)
        {
            if (screen.shown)
                result.append(screen);
        }

        result.append(emptyScreen);
    }

    return result;
}