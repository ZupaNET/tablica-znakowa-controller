#include "categorymodel.h"

QVariant CategoryModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_data.size())
    {
        return {};
    }

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
    Category s = repo.create(name);

    beginInsertRows({}, m_data.size(), m_data.size());

    m_data.append(Category{
        s.id,
        name
    });

    endInsertRows();
}

void CategoryModel::update(int row, const QString& name)
{
    if(row < 0 || row >= m_data.size())
        return;

    auto &s = m_data[row];

    repo.update(s.id, name);

    s.name = name;

    QModelIndex idx = index(row);

    emit dataChanged(idx, idx, {NameRole});
}

void CategoryModel::removeRow(int row)
{
    if(row < 0 || row >= m_data.size())
        return;

    beginRemoveRows({}, row, row);

    repo.remove(m_data[row].id);

    m_data.removeAt(row);

    endRemoveRows();
}

Q_INVOKABLE Category CategoryModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}