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
    void move(int hymnId, int screenId, int from, int to);
};

#endif // SCREENREPOSITORY_H
