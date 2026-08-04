#include "sethymnmodel.h"

QVariant SetHymnModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= m_data.size())
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

QHash<int,QByteArray> SetHymnModel::roleNames() const
{
    return HymnRoles::roleNames();
}

void SetHymnModel::reload()
{
    if(parentId() < 0) updateData(QList<Hymn>());
    else updateData(fetch(parentId()));
}

QList<Hymn> SetHymnModel::fetch(int id)
{
    return repo.getHymns(id);
}

void SetHymnModel::addHymn(int hymnId)
{
    Hymn hymn = repo.addHymn(m_parentId, hymnId);

    int row = m_data.size();

    beginInsertRows({}, row, row);
    m_data.append(hymn);
    endInsertRows();
}

void SetHymnModel::removeHymn(int row) {
    if (row < 0 || row >= m_data.size())
        return;

    repo.removeHymn(m_parentId, m_data[row].id);

    beginRemoveRows({}, row, row);
    m_data.removeAt(row);
    endRemoveRows();
}

void SetHymnModel::move(int from, int to)
{
    if (from == to ||
        from < 0 || from >= m_data.size() ||
        to   < 0 || to   >= m_data.size())
        return;

    beginMoveRows({}, from, from, {}, from < to ? to + 1 : to);
    m_data.move(from, to);
    endMoveRows();

    int movedId = m_data[to].id;
    repo.move(m_parentId, movedId, from, to);
}

Hymn SetHymnModel::get(int index) const{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}