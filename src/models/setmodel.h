#ifndef SETMODEL_H
#define SETMODEL_H

#include "entitylistmodel.h"
#include "roles/setroles.h"
#include "repositories/setrepository.h"

class SetModel : public EntityListModel<Set>, public SetRoles
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit SetModel(QObject *parent = nullptr)
        : EntityListModel<Set>(parent) {}

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(QString name);
    Q_INVOKABLE void removeRow(int row);

private:
    SetRepository repo;
};

#endif // SETMODEL_H
