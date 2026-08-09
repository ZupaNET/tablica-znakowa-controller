#ifndef SETREPOSITORY_H
#define SETREPOSITORY_H

#include "core/dto/set.h"
#include "core/dto/hymn.h"
#include "core/dto/screen.h"
#include <QVariantList>

class SetRepository
{
public:
    QList<Set> getAll();
    Set create(const QString& name);
    void update(int id, QString name);
    void remove(int id);
    void move(int setId, int from, int to);
    QList<Hymn> getHymns(int setId);
    QList<Screen> getScreens(int setId, int hymnId);
    Hymn addHymn(int setId, int hymnId);
    void removeHymn(int setId, int hymnId);
    void move(int setId, int hymnId, int from, int to);
    void changeScreenVisibility(int setId, int screenId, bool shown);
    void changeScreenVisibilityByHymn(int setId, int hymnId, bool shown);

};

#endif // SETREPOSITORY_H
