#ifndef SCREENROLES_H
#define SCREENROLES_H

#include <QHash>
#include <QByteArray>


class ScreenRoles
{

public:

    enum Roles
    {
        IdRole = Qt::UserRole + 1,
        ScreenRole,
        HymnNameRole,
        TextRole,
        OrderRole,
        FontRole,
        ExcerptRole
    };


    static QHash<int,QByteArray> roleNames()
    {
        return {
            {IdRole,"id"},
            {ScreenRole,"screen"},
            {HymnNameRole,"hymnName"},
            {TextRole,"text"},
            {OrderRole,"order"},
            {FontRole,"font"},
            {ExcerptRole,"excerpt"}
        };
    }
};

#endif // SCREENROLES_H
