// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef SETSCREENMODEL_H
#define SETSCREENMODEL_H

#include "models/base/entitylistmodel.h"
#include "domain/roles/screenroles.h"
#include "database/repositories/setrepository.h"

class SetScreenModel : public EntityListModel<Screen>, public ScreenRoles
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int setId READ setId WRITE setSetId NOTIFY setIdChanged)
    Q_PROPERTY(int hymnId READ hymnId WRITE setHymnId NOTIFY hymnIdChanged)
public:

    explicit SetScreenModel(QObject *parent = nullptr)
        : EntityListModel<Screen>(parent) {}

    int setId() const;
    void setSetId(int id);

    int hymnId() const;
    void setHymnId(int id);

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void changeScreenVisibility(int row, bool shown);
    Q_INVOKABLE void changeAllScreenVisibility(bool shown);
    Q_INVOKABLE Screen get(int index) const;

signals:
    void setIdChanged();
    void hymnIdChanged();

private:
    int m_setId = -1, m_hymnId = -1;
    SetRepository repo;
};

#endif // SETSCREENMODEL_H
