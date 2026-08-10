// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef CATEGORYHYMNMODEL_H
#define CATEGORYHYMNMODEL_H

#include "hymnrelationmodel.h"
#include "repositories/categoryrepository.h"
#include "repositories/hymnrepository.h"

class CategoryHymnModel : public HymnRelationModel
{
    Q_OBJECT
    QML_ELEMENT

public:

    explicit CategoryHymnModel(QObject *parent = nullptr)
        : HymnRelationModel(parent) {}

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(const QString& name);
    Q_INVOKABLE void update(int row, const QString& name);
    Q_INVOKABLE void changeCategory(int row, int newCategoryId);
    Q_INVOKABLE void removeRow(int row);
    Q_INVOKABLE Hymn get(int index) const;

protected:

    QList<Hymn> fetch(int id) override;

private:

    CategoryRepository categoryRepo;
    HymnRepository hymnRepo;
};

#endif // CATEGORYHYMNMODEL_H
