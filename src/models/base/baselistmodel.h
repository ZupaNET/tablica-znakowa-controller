// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef BASELISTMODEL_H
#define BASELISTMODEL_H

#include <QAbstractListModel>
#include <QtQml/qqmlregistration.h>

class BaseListModel : public QAbstractListModel
{
public:
    explicit BaseListModel(QObject *parent = nullptr)
        : QAbstractListModel(parent)
    {}

    int rowCount(const QModelIndex& parent = QModelIndex()) const override
    {
        Q_UNUSED(parent)
        return m_rowCount();
    }

    Q_INVOKABLE virtual void reload() = 0;

protected:
    virtual int m_rowCount() const = 0;
};

#endif // BASELISTMODEL_H
