#ifndef HYMNLISTMODEL_H
#define HYMNLISTMODEL_H

#include "baselistmodel.h"
#include "repositories/hymnrepository.h"

class HymnListModel : public BaseListModel
{
    Q_OBJECT
public:
    enum Roles { IdRole = Qt::UserRole+1, NameRole, CategoryRole };

    explicit HymnListModel(QObject *parent = nullptr)
        : BaseListModel(parent) {}

    int rowCount(const QModelIndex&) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override {
        return {
            {IdRole,"id"},
            {NameRole,"name"},
            {CategoryRole,"categoryId"}
        };
    }

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(QString name, int categoryId);
    Q_INVOKABLE void removeRow(int row);

private:
    QList<Hymn> m_data;
    HymnRepository repo;
};

#endif // HYMNLISTMODEL_H
