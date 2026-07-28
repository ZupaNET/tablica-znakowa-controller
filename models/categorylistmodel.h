#ifndef CATEGORYLISTMODEL_H
#define CATEGORYLISTMODEL_H

#include "baselistmodel.h"
#include "repositories/categoryrepository.h"

class CategoryListModel : public BaseListModel
{
    Q_OBJECT
public:
    enum Roles { IdRole=Qt::UserRole+1, NameRole};

    explicit CategoryListModel(QObject *parent = nullptr)
        : BaseListModel(parent) {}

    int rowCount(const QModelIndex&) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override {
        return {
            {IdRole,"id"},
            {NameRole,"name"}
        };
    }

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(QString name);
    Q_INVOKABLE void removeRow(int row);

private:
    QList<Category> m_data;
    CategoryRepository repo;
};

#endif // CATEGORYLISTMODEL_H
