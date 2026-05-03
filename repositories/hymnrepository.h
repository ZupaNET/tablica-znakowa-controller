#ifndef HYMNREPOSITORY_H
#define HYMNREPOSITORY_H

#include "models/dto.h"
#include <QList>

class HymnRepository
{
public:
    QList<Hymn> getAll();
    QList<Hymn> getByCategory(int categoryId);
    int create(const QString& name, int categoryId);
    void update(int id, const QString& name, int categoryId);
    void remove(int id);
};

#endif // HYMNREPOSITORY_H
