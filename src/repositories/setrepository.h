#ifndef SETREPOSITORY_H
#define SETREPOSITORY_H

#include "core/dto/set.h"
#include "core/dto/hymn.h"
#include <QVariantList>

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
    void changeShownScreens(int setId, int hymnId, QVariantList shownScreens);
};

#endif // SETREPOSITORY_H
