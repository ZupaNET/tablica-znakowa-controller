#ifndef HYMNREPOSITORY_H
#define HYMNREPOSITORY_H

#include "core/dto/hymn.h"
#include <QList>

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
