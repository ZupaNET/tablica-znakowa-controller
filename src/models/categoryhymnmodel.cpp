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

void CategoryHymnModel::add(QString name)
{
    hymnRepo.create(name, m_parentId);

    reload();
}


void CategoryHymnModel::removeRow(int row)
{
    if(row < 0 || row >= m_data.size())
        return;

    hymnRepo.remove(
        m_data[row].id
        );

    reload();
}

void CategoryHymnModel::reload()
{
    updateData(fetch(parentId()));
}

Q_INVOKABLE Hymn CategoryHymnModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}

QList<Hymn> CategoryHymnModel::fetch(int id)
{
    return categoryRepo.getHymns(id);
}