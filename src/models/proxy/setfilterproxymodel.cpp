// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "setfilterproxymodel.h"
#include "domain/roles/hymnroles.h"

SetFilterProxyModel::SetFilterProxyModel(QObject *parent)
    : QSortFilterProxyModel{parent}
{}

QAbstractItemModel* SetFilterProxyModel::membershipModel() const
{
    return m_membershipModel;
}

void SetFilterProxyModel::setMembershipModel(QAbstractItemModel* model)
{
    if(m_membershipModel == model)
        return;

    if(m_membershipModel)
    {
        disconnect(m_membershipModel, nullptr, this, nullptr);
    }

    beginFilterChange();

    m_membershipModel = model;

    if(m_membershipModel)
    {
        connect(m_membershipModel, &QAbstractItemModel::modelReset, this, [this](){ beginFilterChange(); rebuild(); endFilterChange(); });
        connect(m_membershipModel, &QAbstractItemModel::rowsInserted, this, [this](){ beginFilterChange(); rebuild(); endFilterChange(); });
        connect(m_membershipModel, &QAbstractItemModel::rowsRemoved, this, [this](){ beginFilterChange(); rebuild(); endFilterChange(); });
        connect(m_membershipModel, &QAbstractItemModel::dataChanged, this, [this](){ beginFilterChange(); rebuild(); endFilterChange(); });
    }

    rebuild();

    endFilterChange();

    emit membershipModelChanged();
}

void SetFilterProxyModel::rebuild()
{
    m_hymnIds.clear();

    if(!m_membershipModel)
        return;

    for(int row = 0; row < m_membershipModel->rowCount(); row++)
    {
        const QModelIndex index = m_membershipModel->index(row,0);
        const int hymnId = m_membershipModel -> data(index, HymnRoles::Roles::IdRole).toInt();
        m_hymnIds.insert(hymnId);
    }
}

bool SetFilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex& sourceParent) const
{
    if(!sourceModel())
        return false;

    const QModelIndex index = sourceModel() -> index(sourceRow, 0, sourceParent);

    const int hymnId = sourceModel() -> data(index, HymnRoles::Roles::IdRole).toInt();

    return !m_hymnIds.contains(hymnId);
}

int SetFilterProxyModel::sourceRow(int proxyRow) const
{
    if (proxyRow < 0 || proxyRow >= rowCount())
        return -1;

    const QModelIndex proxyIndex = index(proxyRow, 0);
    const QModelIndex sourceIndex = mapToSource(proxyIndex);

    return sourceIndex.isValid() ? sourceIndex.row() : -1;
}