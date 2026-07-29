#include "hymnmodel.h"

QVariant HymnModel::data(const QModelIndex& index, int role) const
{
    if(!index.isValid())
        return {};

    const Hymn& item = m_data[index.row()];

    switch(role)
    {
    case IdRole:
        return item.id;

    case NameRole:
        return item.name;

    case CategoryRole:
        return item.categoryId;
    }

    return {};
}

QHash<int,QByteArray> HymnModel::roleNames() const
{
    return HymnRoles::roleNames();
}

void HymnModel::reload()
{
    updateData(repo.getAll());
}


void HymnModel::add(QString name, int categoryId)
{
    repo.create(name, categoryId);

    reload();
}


void HymnModel::removeRow(int row)
{
    if(row < 0 || row >= m_data.size())
        return;

    repo.remove(
        m_data[row].id
        );

    reload();
}
