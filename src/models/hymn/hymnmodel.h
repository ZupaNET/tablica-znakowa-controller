// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef HYMNMODEL_H
#define HYMNMODEL_H

#include "models/base/entitylistmodel.h"
#include "domain/roles/hymnroles.h"
#include "database/repositories/hymnrepository.h"

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
    Q_INVOKABLE Hymn get(int index) const;

private:
    HymnRepository repo;
};

#endif // HYMNMODEL_H
