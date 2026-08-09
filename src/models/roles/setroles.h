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
        NameRole,
        OrderRole
    };


    static QHash<int, QByteArray> roleNames()
    {
        return {
            {IdRole, "id"},
            {NameRole, "name"},
            {OrderRole, "order"}
        };
    }
};

#endif // SETROLES_H
