// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#include "categoryhymnmodel.h"

QVariant CategoryHymnModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_data.size())
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

QHash<int,QByteArray> CategoryHymnModel::roleNames() const
{
    return HymnRoles::roleNames();
}

void CategoryHymnModel::add(const QString& name)
{
    Hymn s = hymnRepo.create(name, m_parentId);

    beginInsertRows({}, m_data.size(), m_data.size());

    m_data.append(Hymn{
        s.id,
        name,
        m_parentId
    });

    endInsertRows();
}


void CategoryHymnModel::update(int row, const QString& name)
{
    if(row < 0 || row >= m_data.size())
        return;

    auto& s = m_data[row];
    s.name = name;

    hymnRepo.update(s.id, s.name, s.categoryId);

    QModelIndex idx = index(row);

    emit dataChanged(idx, idx, {NameRole});
}

void CategoryHymnModel::changeCategory(int row, int newCategoryId)
{
    if(row < 0 || row >= m_data.size())
        return;

    auto& s = m_data[row];
    s.categoryId = newCategoryId;

    hymnRepo.update(s.id, s.name, s.categoryId);

    beginRemoveRows({}, row, row);
    m_data.removeAt(row);
    endRemoveRows();
}

void CategoryHymnModel::removeRow(int row)
{
    if(row < 0 || row >= m_data.size())
        return;

    beginRemoveRows({}, row, row);

    hymnRepo.remove(m_data[row].id);
    m_data.removeAt(row);

    endRemoveRows();
}

void CategoryHymnModel::reload()
{
    if(parentId() < -1) updateData(QList<Hymn>());
    else updateData(fetch(parentId()));
}

Hymn CategoryHymnModel::get(int index) const
{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}

QList<Hymn> CategoryHymnModel::fetch(int id)
{
    return categoryRepo.getHymns(id);
}