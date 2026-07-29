#include "categoryhymnmodel.h"

QVariant CategoryHymnModel::data(const QModelIndex& index, int role) const
{
    const Hymn& item =
        m_data[index.row()];


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

QHash<int,QByteArray> CategoryHymnModel::roleNames() const
{
    return HymnRoles::roleNames();
}

void CategoryHymnModel::reload()
{
    updateData(fetch(parentId()));
}


QList<Hymn> CategoryHymnModel::fetch(int id)
{
    return repo.getHymns(id);
}