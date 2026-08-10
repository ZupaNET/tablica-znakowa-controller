// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "hymnmodel.h"

QVariant HymnModel::data(const QModelIndex& index, int role) const
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

QHash<int,QByteArray> HymnModel::roleNames() const
{
    return HymnRoles::roleNames();
}

void HymnModel::reload()
{
    updateData(repo.getAll());
}


void HymnModel::add(const QString& name, int categoryId)
{
    Hymn s = repo.create(name, categoryId);

    beginInsertRows({}, m_data.size(), m_data.size());

    m_data.append(Hymn{s.id, name, categoryId});

    endInsertRows();
}

void HymnModel::update(int row, const QString& name, int categoryId)
{
    if(row < 0 || row >= m_data.size())
        return;

    auto& s = m_data[row];

    QString newName = s.name;
    int newCategory = s.categoryId;

    if (!name.isNull())
        newName = name;

    if (categoryId >= -1)
        newCategory = categoryId;

    repo.update(s.id, newName, newCategory);

    s.name = newName;
    s.categoryId = newCategory;

    QModelIndex idx = index(row);

    QVector<int> roles;

    if (!name.isNull())
        roles << NameRole;

    if (categoryId >= -1)
        roles << CategoryRole;

    emit dataChanged(idx, idx, roles);;
}

void HymnModel::removeRow(int row)
{
    if(row < 0 || row >= m_data.size())
        return;

    beginRemoveRows({}, row, row);

    repo.remove(m_data[row].id);

    m_data.removeAt(row);

    endRemoveRows();
}
