#ifndef CATEGORYROLES_H
#define CATEGORYROLES_H

#include <QHash>
#include <QByteArray>


class CategoryRoles
{
public:

    enum Roles
    {
        IdRole = Qt::UserRole + 1,
        NameRole
    };


    static QHash<int, QByteArray> roleNames()
    {
        return {
            {IdRole, "id"},
            {NameRole, "name"}
        };
    }
};

#endif // CATEGORYROLES_H
