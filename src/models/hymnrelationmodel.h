// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <devel@zupanet.pl>
 */

#ifndef HYMNRELATIONMODEL_H
#define HYMNRELATIONMODEL_H

#include "entitylistmodel.h"
#include "roles/hymnroles.h"
#include "core/dto/hymn.h"

class HymnRelationModel : public EntityListModel<Hymn>, public HymnRoles
{
    Q_OBJECT

    Q_PROPERTY(int parentId READ parentId WRITE setParentId NOTIFY parentIdChanged)

public:

    explicit HymnRelationModel(QObject* parent = nullptr)
        : EntityListModel<Hymn>(parent)
    {}

    int parentId() const
    {
        return m_parentId;
    }

    void setParentId(int id)
    {
        if(m_parentId == id)
            return;

        m_parentId = id;

        emit parentIdChanged();

        reload();
    }

signals:
    void parentIdChanged();

protected:
    int m_parentId = -1;

    virtual QList<Hymn> fetch(int id) = 0;
};

#endif // HYMNRELATIONMODEL_H
