// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef ENTITYLISTMODEL_H
#define ENTITYLISTMODEL_H

#include "baselistmodel.h"

template<typename T>
class EntityListModel : public BaseListModel
{
public:
    explicit EntityListModel<T>(QObject* parent = nullptr)
        : BaseListModel(parent)
    {}

protected:
    QList<T> m_data;

    int m_rowCount() const override
    {
        return m_data.size();
    }

    void updateData(QList<T> data)
    {
        beginResetModel();
        m_data = std::move(data);
        endResetModel();
    }
};

#endif // ENTITYLISTMODEL_H
