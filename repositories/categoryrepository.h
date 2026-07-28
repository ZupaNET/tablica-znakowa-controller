#ifndef CATEGORYREPOSITORY_H
#define CATEGORYREPOSITORY_H

#include "models/dto.h"
#include <QList>

class CategoryRepository
{
public:
    CategoryRepository();
    QList<Category> getAll();
    int create(QString name);
    void update(int id, QString name);
    void remove(int id);
    QList<Hymn> getHymns(int categoryId);
};

#endif // CATEGORYREPOSITORY_H
