// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef SETFILTERPROXYMODEL_H
#define SETFILTERPROXYMODEL_H

#include <QAbstractItemModel>
#include <QHash>
#include <QSortFilterProxyModel>
#include <QtQml/QtQml>

class SetFilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QAbstractItemModel* membershipModel READ membershipModel WRITE setMembershipModel NOTIFY membershipModelChanged)

public:
    explicit SetFilterProxyModel(QObject *parent = nullptr);

    QAbstractItemModel* membershipModel() const;
    void setMembershipModel(QAbstractItemModel *model);

    Q_INVOKABLE int sourceRow(int proxyRow) const;

signals:
    void membershipModelChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    void rebuild();

    QAbstractItemModel* m_membershipModel = nullptr;
    QSet<int> m_hymnIds;
};

#endif // SETFILTERPROXYMODEL_H
