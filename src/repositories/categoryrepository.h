#ifndef CATEGORYREPOSITORY_H
#define CATEGORYREPOSITORY_H

#include "core/dto/catagory.h"
#include "core/dto/hymn.h"
#include <QList>

class CategoryRepository
{
public:
    CategoryRepository();
    QList<Category> getAll();
    Category create(const QString& name);
    void update(int id, QString name);
    void remove(int id);
    QList<Hymn> getHymns(int categoryId);
    void move(int categoryId, int from, int to);
};

#endif // CATEGORYREPOSITORY_H
