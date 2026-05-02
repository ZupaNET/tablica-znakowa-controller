#ifndef DTO_H
#define DTO_H

#include <QString>

struct Hymn {
    int id;
    QString name;
    int categoryId;
};

struct Screen {
    int id;
    int hymnId;
    QString text;
    int order;
    int font;
};

struct Category {
    int id;
    QString name;
};

struct Set {
    int id;
    QString name;
};

#endif // DTO_H
