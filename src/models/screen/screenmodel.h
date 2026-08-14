// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef SCREENMODEL_H
#define SCREENMODEL_H

#include "models/base/entitylistmodel.h"
#include "domain/roles/screenroles.h"
#include "database/repositories/screenrepository.h"

class ScreenModel : public EntityListModel<Screen>, public ScreenRoles
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int hymnId READ hymnId WRITE setHymnId NOTIFY hymnIdChanged)

public:

    explicit ScreenModel(QObject *parent = nullptr)
        : EntityListModel<Screen>(parent) {}

    int hymnId() const;

    void setHymnId(int id);

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(const QString& text, int font);
    Q_INVOKABLE void update(int row, const QString& text, int font);
    Q_INVOKABLE void duplicate(int row);
    Q_INVOKABLE void removeRow(int row);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE Screen get(int index) const;

    Q_INVOKABLE Screen emptyScreen() const { return Screen::emptyScreen(); }

signals:
    void hymnIdChanged();

private:
    int m_hymnId = -1;
    ScreenRepository repo;
};

#endif // SCREENMODEL_H
