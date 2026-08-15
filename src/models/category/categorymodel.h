// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef CATEGORYMODEL_H
#define CATEGORYMODEL_H

#include "models/base/entitylistmodel.h"
#include "domain/roles/categoryroles.h"
#include "database/repositories/categoryrepository.h"

class CategoryModel : public EntityListModel<Category>, public CategoryRoles
{
    Q_OBJECT
    QML_ELEMENT

public:

    explicit CategoryModel(QObject *parent = nullptr)
        : EntityListModel<Category>(parent) {}

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(const QString& name);
    Q_INVOKABLE void update(int row, const QString& name);
    Q_INVOKABLE void removeRow(int row);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE Category get(int index) const;

private:
    CategoryRepository repo;
};

#endif // CATEGORYMODEL_H
