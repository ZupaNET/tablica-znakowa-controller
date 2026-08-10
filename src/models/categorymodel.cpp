// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "categorymodel.h"

QVariant CategoryModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_data.size())
        return {};

    const Category& item = m_data[index.row()];

    switch(role)
    {
    case IdRole:
        return item.id;

    case NameRole:
        return item.name;

    case OrderRole:
        return item.order;
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


void CategoryModel::add(const QString& name)
{
    Category category = repo.create(name);

    if(category.id < 0)
        return;

    beginInsertRows({}, m_data.size(), m_data.size());

    m_data.append(category);

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

void CategoryModel::move(int from, int to)
{
    if(from <= 0 || to <= 0)
        return;

    if (from == to ||
        from < 0 || from >= m_data.size() ||
        to   < 0 || to   >= m_data.size())
        return;

    beginMoveRows({}, from, from, {}, from < to ? to + 1 : to);
    m_data.move(from, to);
    endMoveRows();

    int movedId = m_data[to].id;
    repo.move(movedId, from-1, to-1);
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

Q_INVOKABLE Category CategoryModel::get(int index) const
{
    if(index < 0 || index >= m_data.size())
        return {};

    const auto& s = m_data[index];

    return s;
}