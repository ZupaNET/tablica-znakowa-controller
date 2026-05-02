#ifndef SETREPOSITORY_H
#define SETREPOSITORY_H

#include "models/dto.h"
#include <QList>

class SetRepository
{
public:
    QList<Set> getAll();
    int create(QString name);
    void update(int id, QString name);
    void remove(int id);
    QList<Hymn> getHymns(int setId);
    void addHymn(int setId, int hymnId);
    void removeHymn(int setId, int hymnId);
    void reorder(int setId, QList<int> ids);
};

#endif // SETREPOSITORY_H
