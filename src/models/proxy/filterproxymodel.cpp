// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#include "filterproxymodel.h"

FilterProxyModel::FilterProxyModel(QObject *parent)
    : QSortFilterProxyModel{parent}
{}

QString FilterProxyModel::filterText() const
{
    return m_filterText;
}

void FilterProxyModel::setFilterText(const QString &text)
{
    if(m_filterText == text)
        return;

    beginFilterChange();

    m_filterText = text;

    endFilterChange();

    emit filterTextChanged();
}

QString FilterProxyModel::filterRole() const
{
    return m_filterRole;
}

void FilterProxyModel::setFilterRole(const QString& role)
{
    if(m_filterRole == role)
        return;

    beginFilterChange();

    m_filterRole = role;
    updateFilterRole();

    endFilterChange();

    emit filterRoleChanged();
}

bool FilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if(m_filterText.trimmed().isEmpty())
        return true;

    const QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);

    const QVariant value = sourceModel()->data(index, m_filterRoleId);

    return value.toString().contains(m_filterText, Qt::CaseInsensitive);
}

void FilterProxyModel::setSourceModel(QAbstractItemModel *model)
{
    QSortFilterProxyModel::setSourceModel(model);

    updateFilterRole();
}

void FilterProxyModel::updateFilterRole()
{
    if (!sourceModel()) {
        m_filterRoleId = Qt::DisplayRole;
        return;
    }

    const auto roles = sourceModel()->roleNames();

    m_filterRoleId = roles.key(
        m_filterRole.toUtf8(),
        Qt::DisplayRole
        );
}

int FilterProxyModel::sourceRow(int proxyRow) const
{
    if (proxyRow < 0 || proxyRow >= rowCount())
        return -1;

    const QModelIndex proxyIndex = index(proxyRow, 0);
    const QModelIndex sourceIndex = mapToSource(proxyIndex);

    return sourceIndex.isValid() ? sourceIndex.row() : -1;
}