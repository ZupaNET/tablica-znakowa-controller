// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef HYMNMODEL_H
#define HYMNMODEL_H

#include "entitylistmodel.h"
#include "roles/hymnroles.h"
#include "repositories/hymnrepository.h"

class HymnModel : public EntityListModel<Hymn>, public HymnRoles
{
    Q_OBJECT
    QML_ELEMENT

public:

    explicit HymnModel(QObject *parent = nullptr)
        : EntityListModel<Hymn>(parent) {}

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(const QString& name, int categoryId);
    Q_INVOKABLE void update(int row, const QString& name, int categoryId);
    Q_INVOKABLE void removeRow(int row);

private:
    HymnRepository repo;
};

#endif // HYMNMODEL_H
