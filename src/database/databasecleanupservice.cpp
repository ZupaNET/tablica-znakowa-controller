// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#include "databasecleanupservice.h"
#include "repositories/categoryrepository.h"
#include "repositories/setrepository.h"

DatabaseCleanupService *DatabaseCleanupService::create(QQmlEngine *, QJSEngine *engine)
{
    // The instance has to exist before it is used. We cannot replace it.
    Q_ASSERT(&instance());

    // The engine has to have the same thread affinity as the singleton.
    Q_ASSERT(engine->thread() == instance().thread());

    // There can only be one engine accessing the singleton.
    if (s_engine)
        Q_ASSERT(engine == s_engine);
    else
        s_engine = engine;

    // Explicitly specify C++ ownership so that the engine doesn't delete
    // the instance.
    QJSEngine::setObjectOwnership(&instance(), QJSEngine::CppOwnership);
    return &instance();
}

void DatabaseCleanupService::reorderCategoriesByName()
{
    CategoryRepository repo;
    repo.reorder();
}

void DatabaseCleanupService::reorderSetsByName()
{
    SetRepository repo;
    repo.reorder();
}