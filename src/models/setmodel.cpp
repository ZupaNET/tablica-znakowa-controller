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
    Set s = repo.create(name);

    beginInsertRows(
        {},
        m_data.size(),
        m_data.size()
        );

    m_data.append(Set{
        s.id,
        name
    });

    endInsertRows();
}

void SetModel::update(int row, const QString& name)
{
    if(row < 0 || row >= m_data.size())
        return;

    auto &s = m_data[row];

    s.name = name;

    repo.update(s.id, s.name);

    QModelIndex idx = index(row);

    emit dataChanged(idx, idx, {NameRole});
}

void SetModel::removeRow(int row)
{
    if(row < 0 || row >= m_data.size())
        return;

    int id = m_data[row].id;

    repo.remove(id);

    beginRemoveRows(
        {},
        row,
        row
        );

    m_data.removeAt(row);

    endRemoveRows();
}

Set SetModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}