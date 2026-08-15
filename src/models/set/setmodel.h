// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef SETMODEL_H
#define SETMODEL_H

#include "models/base/entitylistmodel.h"
#include "domain/roles/setroles.h"
#include "database/repositories/setrepository.h"

class SetModel : public EntityListModel<Set>, public SetRoles
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit SetModel(QObject *parent = nullptr)
        : EntityListModel<Set>(parent) {}

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(const QString& name);
    Q_INVOKABLE void update(int row, const QString& name);
    Q_INVOKABLE void removeRow(int row);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE Set get(int index) const;

private:
    SetRepository repo;
};

#endif // SETMODEL_H
