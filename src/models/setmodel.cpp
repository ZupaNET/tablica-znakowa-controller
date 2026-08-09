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

void SetModel::move(int from, int to)
{
    if(from < 0 || to < 0)
        return;

    if (from == to ||
        from < 0 || from >= m_data.size() ||
        to   < 0 || to   >= m_data.size())
        return;

    beginMoveRows({}, from, from, {}, from < to ? to + 1 : to);
    m_data.move(from, to);
    endMoveRows();

    int movedId = m_data[to].id;
    repo.move(movedId, from, to);
}

Set SetModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}