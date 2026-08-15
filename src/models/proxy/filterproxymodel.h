// SPDX-License-Identifier: GPL-2.0-only
/*
 * Tablica Znakowa - Kontroler
 *
 * Copyright (C) 2026 ŻupaNET Development <dev@zupanet.pl>
 */

#ifndef FILTERPROXYMODEL_H
#define FILTERPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QtQml/QtQml>

class FilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString filterText READ filterText WRITE setFilterText NOTIFY filterTextChanged)
    Q_PROPERTY(QString filterRole READ filterRole WRITE setFilterRole NOTIFY filterRoleChanged)

public:
    explicit FilterProxyModel(QObject *parent = nullptr);

    QString filterText() const;
    void setFilterText(const QString& text);

    QString filterRole() const;
    void setFilterRole(const QString& role);

    Q_INVOKABLE int sourceRow(int proxyRow) const;

signals:
    void filterTextChanged();
    void filterRoleChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

    void setSourceModel(QAbstractItemModel *sourceModel) override;

private:
    QString m_filterText;
    QString m_filterRole = QStringLiteral("name");

    int m_filterRoleId = Qt::DisplayRole;

    void updateFilterRole();
};

#endif // FILTERPROXYMODEL_H
