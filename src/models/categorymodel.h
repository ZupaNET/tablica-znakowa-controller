#ifndef CATEGORYMODEL_H
#define CATEGORYMODEL_H

#include "entitylistmodel.h"
#include "roles/categoryroles.h"
#include "repositories/categoryrepository.h"

class CategoryModel : public EntityListModel<Category>, public CategoryRoles
{
    Q_OBJECT
    QML_ELEMENT

public:

    explicit CategoryModel(QObject *parent = nullptr)
        : EntityListModel<Category>(parent) {}

    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE void reload() override;
    Q_INVOKABLE void add(QString name);
    Q_INVOKABLE void removeRow(int row);

private:
    CategoryRepository repo;
};

#endif // CATEGORYMODEL_H
