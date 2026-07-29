#ifndef SCREENREPOSITORY_H
#define SCREENREPOSITORY_H

#include "core/dto/screen.h"
#include <QList>

class ScreenRepository
{
public:
    QList<Screen> getByHymn(int hymnId);
    int create(int hymnId, QString text, int font);
    void update(int id, QString text, int font);
    void remove(int id);
    void reorder(int hymnId, QList<int> ids);
};

#endif // SCREENREPOSITORY_H
