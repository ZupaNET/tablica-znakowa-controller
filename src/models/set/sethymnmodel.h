// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef SETHYMNMODEL_H
#define SETHYMNMODEL_H

#include "models/hymn/hymnrelationmodel.h"
#include "database/repositories/setrepository.h"

class SetHymnModel : public HymnRelationModel
{
    Q_OBJECT
    QML_ELEMENT

public:

    explicit SetHymnModel(QObject *parent = nullptr)
        : HymnRelationModel(parent) {}

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void addHymn(int hymnId);
    Q_INVOKABLE void removeHymn(int row);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE Hymn get(int index) const;

protected:

    QList<Hymn> fetch(int id) override;

private:

    SetRepository repo;
};

#endif // SETHYMNMODEL_H
