#include "setmodel.h"

QVariant SetModel::data(const QModelIndex& index, int role) const
{
    if(!index.isValid())
        return {};

    const Set& item = m_data[index.row()];

    switch(role)
    {
    case IdRole:
        return item.id;

    case NameRole:
        return item.name;
    }

    return {};
}

QHash<int,QByteArray> SetModel::roleNames() const
{
    return SetRoles::roleNames();
}

void SetModel::reload()
{
    updateData(repo.getAll());
}

void SetModel::add(QString name)
{
    repo.create(name);
    reload();
}

void SetModel::removeRow(int row)
{
    repo.remove(
        m_data[row].id
        );

    reload();
}