#include "categorymodel.h"

QVariant CategoryModel::data(const QModelIndex& index, int role) const
{
    if(!index.isValid())
        return {};

    const Category& item = m_data[index.row()];

    switch(role)
    {
    case IdRole:
        return item.id;

    case NameRole:
        return item.name;
    }

    return {};
}

QHash<int,QByteArray> CategoryModel::roleNames() const
{
    return CategoryRoles::roleNames();
}

void CategoryModel::reload()
{
    updateData(repo.getAll());
}


void CategoryModel::add(QString name)
{
    repo.create(name);
    reload();
}


void CategoryModel::removeRow(int row)
{
    if(row < 0 || row >= m_data.size())
        return;

    repo.remove(m_data[row].id);
    reload();
}

Q_INVOKABLE Category CategoryModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}