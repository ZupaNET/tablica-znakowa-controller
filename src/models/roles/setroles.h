#ifndef SETROLES_H
#define SETROLES_H

#include <QHash>
#include <QByteArray>


class SetRoles
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

#endif // SETROLES_H
